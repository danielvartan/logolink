#' Generate a logolink create_experiment Template
#'
#' Scans a NetLogo XML file (.nlogox) for UI elements (sliders, choosers, 
#' switches), plotting pens, and code procedures to generate a ready-to-run 
#' R script template for `logolink::create_experiment()`.
#'
#' @param model_path A string specifying the path to the .nlogox file.
#' @param print Logical; if TRUE, uses cli to print the result to the console.
#' @param clipboard Logical; if TRUE, copies the generated code to the clipboard.
#'
#' @return A character string containing the generated R code.
#' @import xml2
#' @import stringr
#' @import cli
#' @import checkmate
#' @export
create_experiment_template <- function(
    model_path,
    print = TRUE,
    clipboard = FALSE
) {
  checkmate::assert_file_exists(model_path, extension = "nlogox")
  checkmate::assert_flag(print)
  checkmate::assert_flag(clipboard)
  
  doc <- xml2::read_xml(model_path)
  
  constants_list <- list()
  
  sliders <- xml2::xml_find_all(doc, ".//slider")
  for (s in sliders) {
    name <- xml2::xml_attr(s, "variable")
    if (is.na(name)) name <- xml2::xml_attr(s, "display")
    val <- xml2::xml_attr(s, "default")
    if (!is.na(name) && !is.na(val)) constants_list[[name]] <- val
  }
  
  switches <- xml2::xml_find_all(doc, ".//switch")
  for (sw in switches) {
    name <- xml2::xml_attr(sw, "variable")
    if (is.na(name)) name <- xml2::xml_attr(sw, "display")
    val <- xml2::xml_attr(sw, "on")
    if (!is.na(name) && !is.na(val)) {
      is_true <- tolower(val) == "true"
      constants_list[[name]] <- ifelse(is_true, "TRUE", "FALSE")
    }
  }
  
  choosers <- xml2::xml_find_all(doc, ".//chooser")
  for (c in choosers) {
    name <- xml2::xml_attr(c, "variable")
    if (is.na(name)) name <- xml2::xml_attr(c, "display")
    
    current_idx <- as.numeric(xml2::xml_attr(c, "current")) + 1 
    choice_nodes <- xml2::xml_find_all(c, "./choice")
    choices <- xml2::xml_attr(choice_nodes, "value")
    
    if (!is.na(name) && length(choices) > 0 && !is.na(current_idx)) {
      val <- choices[current_idx]
      if (suppressWarnings(is.na(as.numeric(val)))) {
        val <- paste0("\"", val, "\"")
      }
      constants_list[[name]] <- val
    }
  }
  
  if (length(constants_list) > 0) {
    const_lines <- sapply(names(constants_list), function(n) {
      paste0("    \"", n, "\" = c(", constants_list[[n]], ")")
    })
    constants_str <- paste0(
      "  constants = list(\n", 
      paste(const_lines, collapse = ",\n"), 
      "\n  )"
    )
  } else {
    constants_str <- "  constants = list()"
  }
  
  plot_updates <- xml2::xml_find_all(doc, ".//plot//pen//update")
  plot_texts <- xml2::xml_text(plot_updates)
  
  metrics <- plot_texts[stringr::str_starts(plot_texts, "plot\\s")]
  metrics <- metrics |> 
    stringr::str_remove("plot\\s+") |> 
    stringr::str_trim() |> 
    unique()
  
  if (length(metrics) > 0) {
    metrics_lines <- paste0("    \"", metrics, "\"")
    metrics_str <- paste0(
      "  metrics = c(\n", 
      paste(metrics_lines, collapse = ",\n"), 
      "\n  )"
    )
  } else {
    metrics_str <- "  metrics = NULL"
  }
  
  code_nodes <- xml2::xml_find_all(doc, ".//code")
  code_text <- paste(xml2::xml_text(code_nodes), collapse = "\n")
  
  has_setup <- stringr::str_detect(
    code_text, 
    stringr::regex("^\\s*to\\s+setup\\b", multiline = TRUE, ignore_case = TRUE)
  )
  setup_str <- if (has_setup) "\"setup\"" else "NULL"
  
  has_go <- stringr::str_detect(
    code_text, 
    stringr::regex("^\\s*to\\s+go\\b", multiline = TRUE, ignore_case = TRUE)
  )
  go_str <- if (has_go) "\"go\"" else "NULL"
  
  template <- paste0(
    "create_experiment(\n",
    "  name = \"Auto-Generated Analysis\",\n",
    "  repetitions = 1,\n",
    "  run_metrics_every_step = TRUE,\n",
    "  setup = ", setup_str, ",\n",
    "  go = ", go_str, ",\n",
    "  time_limit = 200,\n",
    metrics_str, ",\n",
    constants_str, "\n",
    ")\n"
  )
  
  if (print) {
    cli::cli_code(template)
  }
  
  if (clipboard) {
    if (requireNamespace("clipr", quietly = TRUE)) {
      clipr::write_clip(template)
      cli::cli_alert_success("Template successfully copied to clipboard.")
    } else {
      cli::cli_alert_warning(
        "Package {.pkg clipr} is required to copy to clipboard. Please install it using {.code install.packages('clipr')}."
      )
    }
  }
  
  invisible(template)
}
