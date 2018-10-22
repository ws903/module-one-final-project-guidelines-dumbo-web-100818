require_relative '../config/environment'

Stock.collect_from_api(ticker_name: "FB")
