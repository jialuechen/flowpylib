<div align=center>

# FlowPylib: Python Library for Order Flow Inference and Transaction Cost Analytics

</div>

<div align=center>

[![PyPI - Version](https://img.shields.io/pypi/v/pytca)](https://pypi.org/project/flowpylib/)
[![Python Versions](https://img.shields.io/badge/python-3.6%2B-green)](https://pypi.org/project/flowpylib/)
[![License](https://img.shields.io/badge/License-BSD%202--Clause-orange.svg)](https://opensource.org/licenses/BSD-2-Clause)

</div>

**FlowPylib** is a Python package for transaction cost analysis in financial markets, supporting both stock and forex data at the tick level. The library assists traders and market makers by enabling detailed analysis of market data, reconstruction of metaorders, and simulation of order flows. It also provides various visualization tools and a RESTful API to integrate the analytics into your systems.

## Features

- **Tick Data Processing:**  
  Process high-frequency tick data for stocks and forex.

- **MetaOrder Reconstruction:**  
  Reconstruct realistic metaorders using public tick data as ground truth, enabling offline pre-trade cost estimation and execution optimization.

- **Bayesian Change-Point Detection:**  
  Detect regime shifts in order flow to help market makers adjust quoting skew and manage inventory exposure in real time.

- **Buy-Side Order Flow Simulation:**  
  Simulate buy-side order flow to estimate the number of trades required to detect directional alpha in client order flow.

- **Rich Visualizations & Reporting:**  
  Generate interactive charts and dashboards, including candlestick charts, trade flow visualizations, and summary dashboards.

- **RESTful API Integration:**  
  Run an API server to provide analysis as a service, making it easy to integrate with other systems.

- **Multi-Source Data Loading:**  
  Supports CSV, Excel, SQL, KDB+, and other RDBMS data sources.

## Installation and Quick Start
```bash
pip install -U flowpylib
```

```python
import flowpylib

# Load tick data (supports stocks, forex, etc.)
tick_data = flowpylib.load_tick_data('path/to/tick_data.csv', data_type='stock')

# Analyze the tick data
analysis_results = flowpylib.analyze_tick_data(tick_data)
print("Tick Data Analysis Results:", analysis_results)

# Visualize tick data with a summary dashboard
summary_fig = flowpylib.plot_tick_data(tick_data, plot_type='summary')
summary_fig.write_html('summary_dashboard.html')
```

## More Examples

### Loading Data from Different Sources

```python
import flowpylib

# From CSV
csv_data = flowpylib.load_tick_data('path/to/tick_data.csv', data_type='stock')

# From Excel
excel_data = flowpylib.read_excel('path/to/tick_data.xlsx', sheet_name='Tick Data')

# Using KDBHandler for KDB+ source
kdb_handler = flowpylib.KDBHandler(host='localhost', port=5000)
kdb_data = kdb_handler.load_tick_data('tickdata', '2023.07.15T09:30:00.000', '2023.07.15T16:00:00.000')
```

### Performing Analysis

```python
import flowpylib

# Load data for stocks and forex
stock_data = flowpylib.load_tick_data('path/to/stock_data.csv', data_type='stock')
forex_data = flowpylib.load_tick_data('path/to/forex_data.csv', data_type='forex')

# Analyze stock data
stock_analysis = flowpylib.analyze_stock_trade(stock_data, benchmark_data)
print("Stock Analysis Results:", stock_analysis)

# Analyze forex data
forex_analysis = flowpylib.analyze_forex_trade(forex_data, benchmark_data)
print("Forex Analysis Results:", forex_analysis)

# Calculate slippage and VWAP as examples
slippage = flowpylib.calculate_slippage(executed_price=100.05, benchmark_price=100.00)
print("Slippage:", slippage)

vwap = flowpylib.calculate_vwap(prices=[100.00, 100.05, 100.10], volumes=[1000, 2000, 1500])
print("VWAP:", vwap)
```

### Generating Visualizations

```python
import flowpylib

# Load tick data
tick_data = flowpylib.load_tick_data('path/to/tick_data.csv', data_type='stock')

# Create a basic plot
basic_fig = flowpylib.plot_tick_data(tick_data, plot_type='basic')
basic_fig.savefig('basic_plot.png')

# Create a candlestick chart
candlestick_fig = flowpylib.plot_tick_data(tick_data, plot_type='candlestick', interval='5min')
candlestick_fig.write_html('candlestick.html')

# Create an order book depth chart
depth_fig = flowpylib.plot_tick_data(tick_data, plot_type='depth')
depth_fig.write_html('depth_chart.html')

# Create a trade flow chart
trade_flow_fig = flowpylib.plot_tick_data(tick_data, plot_type='trade_flow', window='5min')
trade_flow_fig.write_html('trade_flow.html')

# Create a summary dashboard
summary_fig = flowpylib.plot_tick_data(tick_data, plot_type='summary')
summary_fig.write_html('summary_dashboard.html')
```

### Using the RESTful API

```python
import flowpylib

# Start the API server
flowpylib.run_api(host='localhost', port=5000)

# Now you can make HTTP requests to the API endpoints, for example:
# POST http://localhost:5000/analyze_tick_data
# with JSON body: {"table_name": "tickdata", "start_time": "2023.07.15T09:30:00.000", "end_time": "2023.07.15T16:00:00.000", "symbols": ["AAPL", "GOOGL"]}
```

## Roadmap

- **Q4 2024:**  
  - Implement an order flow simulator capable of generating large-scale alpha-less orders, i.e., unbiased trades from randomized interventional experiments.

- **Q1 2025:**  
  - Enhance metaorder reconstruction with uncertainty quantification and sensitivity analysis.  
  - Integrate additional data sources including real-time market data feeds and alternative asset classes.

- **Q2 2025:**  
  - Develop real-time interactive dashboards for monitoring key trading metrics and risk exposure.  
  - Introduce predictive machine learning modules for market behavior analysis.

- **Q3 2025:**  
  - Expand API capabilities to support advanced query parameters and data aggregation functions.  
  - Add a comprehensive backtesting framework for systematic strategy simulations and scenario analysis.

- **Q4 2025:**  
  - Optimize performance and scalability for handling high-frequency tick data.  
  - Incorporate advanced risk management tools focusing on inventory and market exposure mitigation.

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

This project is licensed under the BSD-2-Clause License - see the [LICENSE](LICENSE) file for details.
