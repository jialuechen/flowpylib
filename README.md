<div align=center>

# FlowPylib: Python Library for Trading Cost and Liquidity Analytics

</div>

<div align=center>

[![PyPI - Version](https://img.shields.io/pypi/v/flowpylib)](https://pypi.org/project/flowpylib/)
[![Python Versions](https://img.shields.io/badge/python-3.6%2B-green)](https://pypi.org/project/flowpylib/)
![PyPI downloads](https://img.shields.io/pypi/dm/flowpylib)
[![Documentation Status](https://readthedocs.org/projects/flowpylib/badge/?version=latest)](https://flowpylib.readthedocs.io/en/latest/?badge=latest)
[![License](https://img.shields.io/badge/License-BSD%202--Clause-orange.svg)](https://opensource.org/licenses/BSD-2-Clause)
[![Coverage Status](https://coveralls.io/repos/github/jialuechen/flowpylib/badge.svg?branch=main)](https://coveralls.io/github/jialuechen/flowpylib?branch=main)

</div>

**FlowPylib** is a Python package for transaction cost analysis in financial markets, supporting both stock and forex data at the tick level.

## Features

- Support tick-level data processing and analytics for stocks and forex
- Perform various analyses including slippage, market impact, and timing cost and Calculate key metrics such as VWAP and implementation shortfall
- Generate visualizations and reports
- Enable RESTful API for integration with other systems
- Support for Excel and KDB+ as well as well as other RDBMS data sources

## Installation

```bash
pip install -U flowpylib
```

## Quick Start

```python
import flowpylib

# Load tick data
tick_data = flowpylib.load_tick_data('path/to/tick_data.csv', data_type='stock')

# Analyze tick data
analysis_results = flowpylib.analyze_tick_data(tick_data)
print("Tick Data Analysis Results:", analysis_results)

# Visualize tick data
fig = flowpylib.plot_tick_data(tick_data, plot_type='summary')
fig.write_html('tick_data_summary.html')
```

## More Examples

### Loading Data from Different Sources

```python
import flowpylib

# Load data from CSV
csv_data = flowpylib.load_tick_data('path/to/tick_data.csv', data_type='stock')

# Load data from Excel
excel_data = flowpylib.read_excel('path/to/tick_data.xlsx', sheet_name='Tick Data')

# Load data from KDB
kdb_handler = flowpylib.KDBHandler(host='localhost', port=5000)
kdb_data = kdb_handler.load_tick_data('tickdata', '2023.07.15T09:30:00.000', '2023.07.15T16:00:00.000')
```

### Performing Analysis

```python
import flowpylib

# Load data
stock_data = flowpylib.load_tick_data('path/to/stock_data.csv', data_type='stock')
forex_data = flowpylib.load_tick_data('path/to/forex_data.csv', data_type='forex')

# Analyze stock data
stock_analysis = flowpylib.analyze_stock_trade(stock_data, benchmark_data)
print("Stock Analysis Results:", stock_analysis)

# Analyze forex data
forex_analysis = flowpylib.analyze_forex_trade(forex_data, benchmark_data)
print("Forex Analysis Results:", forex_analysis)

# Calculate slippage
slippage = flowpylib.calculate_slippage(executed_price=100.05, benchmark_price=100.00)
print("Slippage:", slippage)

# Calculate VWAP
vwap = flowpylib.calculate_vwap(prices=[100.00, 100.05, 100.10], volumes=[1000, 2000, 1500])
print("VWAP:", vwap)
```

### Generating Visualizations

```python
import flowpylib

# Load data
tick_data = flowpylib.load_tick_data('path/to/tick_data.csv', data_type='stock')

# Create basic plot
basic_fig = flowpylib.plot_tick_data(tick_data, plot_type='basic')
basic_fig.savefig('basic_plot.png')

# Create candlestick chart
candlestick_fig = flowpylib.plot_tick_data(tick_data, plot_type='candlestick', interval='5min')
candlestick_fig.write_html('candlestick.html')

# Create order book depth chart
depth_fig = flowpylib.plot_tick_data(tick_data, plot_type='depth')
depth_fig.write_html('depth_chart.html')

# Create trade flow chart
trade_flow_fig = flowpylib.plot_tick_data(tick_data, plot_type='trade_flow', window='5min')
trade_flow_fig.write_html('trade_flow.html')

# Create summary dashboard
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
Q4 2024: Implement an order flow simulator which can generate large-scale alpha-less orders,i.e., unbiased trades from randomized interventional experiments.

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

This project is licensed under the BSD-2-Clause License - see the [LICENSE](LICENSE) file for details.
