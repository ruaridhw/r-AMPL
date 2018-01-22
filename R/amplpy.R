new_ampl_env <- function(amplpy = import("amplpy"),
                         ampl_path = "/Applications/ampl") {
  amplpy$AMPL(amplpy$Environment(ampl_path))
}
