##Taller UseR!2022=group
##esquisse=name
##Making a ggplot2 interactively=display_name
##Layer=vector
##Language=optional enum literal en;es;fr;al;mk

library(shiny)
library(shinyjs)
library(rlang)
library(esquisse)

if(is.null(Language)) Language  <- "en"
if(packageVersion("esquisse") <= package_version("1.1.0")){
  if(Language == "al") Language <- "sq"
}

if(Language != "en" &
   file.exists(system.file("i18n",
                           paste0(Language, ".csv"),
                           package = "esquisse"))) {
  set_i18n(Language)
  warning(sprintf("esquisse version %s installed doesn't have this language translation yet.\nTry with newest versions.", 
                  packageVersion("esquisse")))
}

jscode <- "shinyjs.closeWindow = function() { window.close(); }"

res_data <- esquisse:::get_data(Layer, name = deparse(substitute(Layer)))
if (!is.null(res_data$esquisse_data)) {
  res_data$esquisse_data <- esquisse:::dropListColumns(res_data$esquisse_data)
}
rv <- reactiveValues(
  data = res_data$esquisse_data,
  name = res_data$esquisse_data_name
)
controls = c("labs", "parameters", "appearance", "filters", "code")
inviewer <- browserViewer(browser = getOption("browser"))

play_pause_input <- function(inputId) {
  play_pause <- shinyWidgets::prettyToggle(
    inputId = inputId,
    value = TRUE,
    label_on = "Play",
    label_off = "Pause",
    outline = TRUE,
    plain = TRUE,
    bigger = TRUE,
    inline = TRUE,
    icon_on = phosphoricons::ph_i("play-circle"),
    icon_off = phosphoricons::ph_i("pause-circle")
  )
  play_pause$attribs$style <- "display: inline-block; margin-right: -5px;"
  tags$div(
    # style = "position: absolute; right: 0; top: 35px; font-weight: bold; z-index: 1000;",
    style = "position: absolute; right: 40px; top: 5px; font-weight: bold; z-index: 1000;",
    play_pause
  )
}

esquisse_ui <- function(id,
                        header = TRUE,
                        container = esquisseContainer(),
                        controls = c("labs", "parameters", "appearance", "filters", "code"),
                        insert_code = FALSE) {
  ns <- NS(id)
  tag_header <- tags$div(
    class = "esquisse-title-container",
    tags$h1("Esquisse", class = "esquisse-title"),
    tags$div(
      class = "pull-right",
      actionButton(
        inputId = ns("settings"),
        label = ph("gear-six", height = "2em"),
        class = "btn-sm",
        title = esquisse::i18n("Display settings")
      ),
      actionButton(
        inputId = ns("close"),
        label = ph("x", height = "2em"),
        class = "btn-sm",
        title = esquisse::i18n("Close Window")
      )
    ),
    tags$div(
      class = "pull-left",
      actionButton(
        inputId = ns("launch_import_data"),
        label = ph("database", height = "2em"),
        class = "btn-sm",
        title = esquisse::i18n("Import data")
      ),
      actionButton(
        inputId = ns("show_data"),
        label = ph("table", height = "2em"),
        class = "btn-sm",
        title = esquisse::i18n("Show data")
      )
    )
  )
  
  ui <- fillPage(
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = jscode, functions = c("closeWindow")),
    tags$div(
      class = "esquisse-container",
      esquisse:::html_dependency_esquisse(),
      esquisse:::html_dependency_clipboard(),
      # shinyWidgets::chooseSliderSkin("Modern", "#112446"),
      
      if (isTRUE(header)) tag_header,
      
      tags$div(
        class = "esquisse-geom-aes",
        tags$div(
          style = "padding: 3px 3px 0 3px; height: 144px;",
          dropInput(
            inputId = ns("geom"),
            choicesNames = esquisse:::geomIcons()$names,
            choicesValues = esquisse:::geomIcons()$values,
            dropWidth = "290px",
            width = "100%"
          )
        ),
        uiOutput(outputId = ns("ui_aesthetics"))
      ),
      
      fillCol(
        style = "overflow-y: auto;",
        tags$div(
          style = "height: 100%; min-height: 400px;",
          play_pause_input(ns("play_plot")),
          esquisse:::ggplot_output(id = ns("plooooooot"), width = "100%", height = "100%")
        )
      ),
      
      esquisse:::controls_ui(
        id = ns("controls"),
        insert_code = insert_code,
        controls = controls
      )
    ))
  
  if (is.function(container)) {
    ui <- esquisse:::container(ui)
  }
  return(ui)
}
# Server ---

esquisse_server <- function(id,
                            data_rv = NULL,
                            default_aes = c("fill", "color", "size", "group", "facet"),
                            import_from = c("env", "file", "copypaste", "googlesheets")) {
  
  moduleServer(
    id = id,
    module = function(input, output, session) {
      session$onSessionEnded(function() {
        stopApp()
      })
      ns <- session$ns
      ggplotCall <- reactiveValues(code = "")
      data_chart <- reactiveValues(data = NULL, name = NULL)
      
      # Settings modal (aesthetics choices)
      observeEvent(input$settings, {
        showModal(esquisse:::modal_settings(aesthetics = input$aesthetics))
      })
      
      # Generate drag-and-drop input
      output$ui_aesthetics <- renderUI({
        if (is.reactive(default_aes)) {
          aesthetics <- default_aes()
        } else {
          if (is.null(input$aesthetics)) {
            aesthetics <- default_aes
          } else {
            aesthetics <- input$aesthetics
          }
        }
        data <- isolate(data_chart$data)
        if (!is.null(data)) {
          var_choices <- esquisse:::get_col_names(data)
          esquisse::dragulaInput(
            inputId = ns("dragvars"),
            sourceLabel = "Variables",
            targetsLabels = c("X", "Y", aesthetics),
            targetsIds = c("xvar", "yvar", aesthetics),
            choiceValues = var_choices,
            choiceNames = esquisse:::badgeType(
              col_name = var_choices,
              col_type = esquisse:::col_type(data[, var_choices, drop = TRUE])
            ),
            selected = esquisse:::dropNulls(isolate(input$dragvars$target)),
            badge = FALSE,
            width = "100%",
            height = "70px",
            replace = TRUE
          )
        } else {
          esquisse:::dragulaInput(
            inputId = ns("dragvars"),
            sourceLabel = "Variables",
            targetsLabels = c("X", "Y", aesthetics),
            targetsIds = c("xvar", "yvar", aesthetics),
            choices = "",
            badge = FALSE,
            width = "100%",
            height = "70px",
            replace = TRUE
          )
        }
      })
      
      observeEvent(data_rv$data, {
        data_chart$data <- data_rv$data
        data_chart$name <- data_rv$name
      }, ignoreInit = FALSE)
      
      # Launch import modal if no data at start
      if (is.null(isolate(data_rv$data))) {
        datamods::import_modal(
          id = ns("import-data"),
          from = import_from,
          title = esquisse::i18n("Import data to create a graph")
        )
      }
      
      # Launch import modal if button clicked
      observeEvent(input$launch_import_data, {
        datamods::import_modal(
          id = ns("import-data"),
          from = import_from,
          title = esquisse::i18n("Import data to create a graph")
        )
      })
      
      # Data imported and update rv used
      data_imported_r <- datamods::import_server("import-data", return_class = "tbl_df")
      observeEvent(data_imported_r$data(), {
        data <- data_imported_r$data()
        data_chart$data <- data
        data_chart$name <- data_imported_r$name() %||% "imported_data"
      })
      
      observeEvent(input$show_data, {
        data <- controls_rv$data
        if (!is.data.frame(data)) {
          showNotification(
            ui = "No data to display",
            duration = 700,
            id = paste("esquisse", sample.int(1e6, 1), sep = "-"),
            type = "warning"
          )
        } else {
          datamods::show_data(data, title = esquisse::i18n("Dataset"), type = "modal")
        }
      })
      
      # Update drag-and-drop input when data changes
      observeEvent(data_chart$data, {
        data <- data_chart$data
        if (is.null(data)) {
          updateDragulaInput(
            session = session,
            inputId = "dragvars",
            status = NULL,
            choices = character(0),
            badge = FALSE
          )
        } else {
          # special case: geom_sf
          if (inherits(data, what = "sf")) {
            geom_possible$x <- c("sf", geom_possible$x)
          }
          var_choices <- esquisse:::get_col_names(data)
          updateDragulaInput(
            session = session,
            inputId = "dragvars",
            status = NULL,
            choiceValues = var_choices,
            choiceNames = esquisse:::badgeType(
              col_name = var_choices,
              col_type = esquisse:::col_type(data[, var_choices, drop = TRUE])
            ),
            badge = FALSE
          )
        }
      }, ignoreNULL = FALSE)
      
      geom_possible <- reactiveValues(x = "auto")
      geom_controls <- reactiveValues(x = "auto")
      observeEvent(list(input$dragvars$target, input$geom), {
        geoms <- potential_geoms(
          data = data_chart$data,
          mapping = build_aes(
            data = data_chart$data,
            x = input$dragvars$target$xvar,
            y = input$dragvars$target$yvar
          )
        )
        geom_possible$x <- c("auto", geoms)
        
        geom_controls$x <- esquisse:::select_geom_controls(input$geom, geoms)
        
        if (!is.null(input$dragvars$target$fill) | !is.null(input$dragvars$target$color)) {
          geom_controls$palette <- TRUE
        } else {
          geom_controls$palette <- FALSE
        }
      }, ignoreInit = TRUE)
      
      observeEvent(geom_possible$x, {
        geoms <- c(
          "auto", "line", "area", "bar", "col", "histogram",
          "point", "jitter", "boxplot", "violin", "density",
          "tile", "sf"
        )
        updateDropInput(
          session = session,
          inputId = "geom",
          selected = setdiff(geom_possible$x, "auto")[1],
          disabled = setdiff(geoms, geom_possible$x)
        )
      })
      
      # Module chart controls : title, xlabs, colors, export...
      # paramsChart <- reactiveValues(inputs = NULL)
      controls_rv <- esquisse:::controls_server(
        id = "controls",
        type = geom_controls,
        data_table = reactive(data_chart$data),
        data_name = reactive({
          nm <- req(data_chart$name)
          if (rlang::is_call(nm)) {
            nm <- rlang::as_label(nm)
          }
          nm
        }),
        ggplot_rv = ggplotCall,
        aesthetics = reactive({
          esquisse:::dropNullsOrEmpty(input$dragvars$target)
        }),
        use_facet = reactive({
          !is.null(input$dragvars$target$facet) | !is.null(input$dragvars$target$facet_row) | !is.null(input$dragvars$target$facet_col)
        }),
        use_transX = reactive({
          if (is.null(input$dragvars$target$xvar))
            return(FALSE)
          identical(
            x = esquisse:::col_type(data_chart$data[[input$dragvars$target$xvar]]),
            y = "continuous"
          )
        }),
        use_transY = reactive({
          if (is.null(input$dragvars$target$yvar))
            return(FALSE)
          identical(
            x = esquisse:::col_type(data_chart$data[[input$dragvars$target$yvar]]),
            y = "continuous"
          )
        })
      )
      
      
      render_ggplot("plooooooot", {
        req(input$play_plot, cancelOutput = TRUE)
        req(data_chart$data)
        req(controls_rv$data)
        req(controls_rv$inputs)
        req(input$geom)
        
        aes_input <- esquisse:::make_aes(input$dragvars$target)
        
        req(unlist(aes_input) %in% names(data_chart$data))
        
        mapping <- build_aes(
          data = data_chart$data,
          .list = aes_input,
          geom = input$geom
        )
        
        geoms <- esquisse:::potential_geoms(
          data = data_chart$data,
          mapping = mapping
        )
        req(input$geom %in% geoms)
        
        data <- controls_rv$data
        
        scales <- esquisse:::which_pal_scale(
          mapping = mapping,
          palette = controls_rv$colors$colors,
          data = data,
          reverse = controls_rv$colors$reverse
        )
        
        if (identical(input$geom, "auto")) {
          geom <- "blank"
        } else {
          geom <- input$geom
        }
        
        geom_args <- esquisse:::match_geom_args(input$geom, controls_rv$inputs, mapping = mapping)
        
        if (isTRUE(controls_rv$smooth$add) & input$geom %in% c("point", "line")) {
          geom <- c(geom, "smooth")
          geom_args <- c(
            setNames(list(geom_args), input$geom),
            list(smooth = controls_rv$smooth$args)
          )
        }
        if (isTRUE(controls_rv$jitter$add) & input$geom %in% c("boxplot", "violin")) {
          geom <- c(geom, "jitter")
          geom_args <- c(
            setNames(list(geom_args), input$geom),
            list(jitter = controls_rv$jitter$args)
          )
          
        }
        if (!is.null(aes_input$ymin) & !is.null(aes_input$ymax) & input$geom %in% c("line")) {
          geom <- c("ribbon", geom)
          mapping_ribbon <- aes_input[c("ymin", "ymax")]
          geom_args <- c(
            list(ribbon = list(
              mapping = ralng::expr(aes(!!!rlang::syms2(mapping_ribbon))),
              fill = controls_rv$inputs$color_ribbon
            )),
            setNames(list(geom_args), input$geom)
          )
          mapping$ymin <- NULL
          mapping$ymax <- NULL
        }
        
        scales_args <- scales$args
        scales <- scales$scales
        
        if (isTRUE(controls_rv$transX$use)) {
          scales <- c(scales, "x_continuous")
          scales_args <- c(scales_args, list(x_continuous = controls_rv$transX$args))
        }
        
        if (isTRUE(controls_rv$transY$use)) {
          scales <- c(scales, "y_continuous")
          scales_args <- c(scales_args, list(y_continuous = controls_rv$transY$args))
        }
        
        if (isTRUE(controls_rv$limits$x)) {
          xlim <- controls_rv$limits$xlim
        } else {
          xlim <- NULL
        }
        if (isTRUE(controls_rv$limits$y)) {
          ylim <- controls_rv$limits$ylim
        } else {
          ylim <- NULL
        }
        data_name <- data_chart$name %||% "data"
        gg_call <- esquisse:::ggcall(
          data = data_name,
          mapping = mapping,
          geom = geom,
          geom_args = geom_args,
          scales = scales,
          scales_args = scales_args,
          labs = controls_rv$labs,
          theme = controls_rv$theme$theme,
          theme_args = controls_rv$theme$args,
          coord = controls_rv$coord,
          facet = input$dragvars$target$facet,
          facet_row = input$dragvars$target$facet_row,
          facet_col = input$dragvars$target$facet_col,
          facet_args = controls_rv$facet,
          xlim = xlim,
          ylim = ylim
        )
        
        ggplotCall$code <- esquisse:::deparse2(gg_call)
        ggplotCall$call <- gg_call
        
        ggplotCall$ggobj <- esquisse:::safe_ggplot(
          expr = rlang::expr((!!gg_call) %+% !!rlang::sym("esquisse_data")),
          data = setNames(list(data, data), c("esquisse_data", data_chart$name))
        )
        ggplotCall$ggobj$plot
      }, filename = "esquisse-plot")
      
      
      # Close addin
      observeEvent(input$close, {
        js$closeWindow()
        shiny::stopApp()}
      )
      
      # Ouput of module (if used in Shiny)
      output_module <- reactiveValues(code_plot = NULL, code_filters = NULL, data = NULL)
      observeEvent(ggplotCall$code, {
        output_module$code_plot <- ggplotCall$code
      }, ignoreInit = TRUE)
      observeEvent(controls_rv$data, {
        output_module$code_filters <- controls_rv$code
        output_module$data <- controls_rv$data
      }, ignoreInit = TRUE)
      
      return(output_module)
    }
  )
  
}

tryCatch(
  # Run app----
  runGadget(
    app = esquisse_ui(
      id = "esquisse",
      container = NULL,
      insert_code = FALSE,
      controls = controls
    ),
    server = function(input, output, session) {
      esquisse_server("esquisse", rv)
    },
    viewer = inviewer
  ),
  
  finally = message("Plots and outputs exported using esquisse app.")
)
