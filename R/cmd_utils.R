#' Check if value matches a pre-defined list of values
check_choose_from <- function(choices) {
    if (length(choices) == 0) {
        stop(paste0('Choice is empty for "', opt_flag, '".'))
    }
    function(opt, opt_flag, opt_value, parser, choices. = choices) {
        if (is.na(opt_value)) {
            opt_value <- choices.[1]
        } else if (length(opt_value) != 1) {
            stop(
                paste0('Expects a single value for "', opt_flag, '".'),
                call. = FALSE
            )
        } else if (! opt_value %in% choices.) {
            stop(
                paste0(
                    'Supplied value "', opt_value, '" for "', opt_flag,
                    '" is not one of [', paste(choices., collapse = ', '), '].'
                ),
                call. = FALSE
            )
        }
        opt_value
    }
}

#' Parse a string of comma-separated values into a vector
parse_comma_separated_values <- function(sep = ',') {
    function(opt, opt_flag, opt_value, parser, sep. = sep) {
        strsplit(opt_value, sep., fixed = T)[[1]]
    }
}


#' Take a list of options and positional arguments, and parse the command line
get_opts <- function(arguments, args) {
    k_opts <- sapply(arguments, class) == 'OptionParserOption'
    option_list <- arguments[k_opts]
    argument_list <- arguments[!k_opts]
    argument_dests <- names(argument_list)

    usage <- paste(
        paste('Usage: monocle3', args[1], '[options]'),
        paste(
            sapply(argument_list, function(arg) arg$name),
            collapse = ' '
        )
    )

    description <- paste(
        sapply(
            argument_list,
            function(arg) {
                paste0('\n', paste(arg$name, arg$help, sep = ':\n\t\t'))
            }
        ),
        sep = '\n'
    )

    parsed <- parse_args(
        OptionParser(
            option_list = option_list,
            usage = usage,
            description = description
        ),
        args = args[-1],
        convert_hyphens_to_underscores = TRUE,
        positional_arguments = length(argument_list)
    )

    parsed$args <- mapply(
        function(arg, x) arg[['type']](x),
        argument_list,
        parsed$args,
        SIMPLIFY = FALSE,
        USE.NAMES = TRUE
    )
    c(parsed$options, as.list(parsed$args))
}

#' Pre-parse command line args to get sub-command
get_sub_command_args <- function(command_spec, usage) {
    args <- commandArgs(trailing=TRUE)
    if (length(args) == 0 || args[1] %in% c('-h', '--help')) {
        message(usage)
        q(save = 'no', status = 0)
    }

    cmd <- args[1]

    if (!cmd %in% command_spec$name) stop(paste('Unrecognised command:', cmd), call. = FALSE)

    args
}
