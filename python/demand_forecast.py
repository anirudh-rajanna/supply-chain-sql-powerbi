import pandas as pd
from prophet import Prophet
import matplotlib.pyplot as plt
import os

# Load data
print("Loading data...")
df = pd.read_csv('../data/DataCoSupplyChainDataset.csv', encoding='latin-1')

# Parse dates
df['order_date'] = pd.to_datetime(df['order date (DateOrders)'], format='%m/%d/%Y %H:%M')
df['month'] = df['order_date'].dt.to_period('M').dt.to_timestamp()

# Aggregate by category + month
monthly = df.groupby(['Category Name', 'month'])['Order Item Quantity'].sum().reset_index()
monthly.columns = ['category', 'ds', 'y']

# Forecast each category
all_forecasts = []
categories = monthly['category'].unique()
print(f"Forecasting {len(categories)} categories...")

for cat in categories:
    cat_df = monthly[monthly['category'] == cat][['ds', 'y']].copy()
    if len(cat_df) < 6:
        continue

    model = Prophet(yearly_seasonality=True,
                    weekly_seasonality=False,
                    daily_seasonality=False)
    model.fit(cat_df)

    future = model.make_future_dataframe(periods=6, freq='MS')
    forecast = model.predict(future)

    forecast['category'] = cat
    forecast['is_forecast'] = forecast['ds'] > cat_df['ds'].max()
    all_forecasts.append(forecast[['ds', 'category',
                                    'yhat', 'yhat_lower',
                                    'yhat_upper', 'is_forecast']])
    print(f"  Done: {cat}")

# Combine and export
results = pd.concat(all_forecasts, ignore_index=True)
results.columns = ['date', 'category', 'forecast_qty',
                    'lower_bound', 'upper_bound', 'is_forecast']

os.makedirs('output', exist_ok=True)
results.to_csv('output/forecast_results.csv', index=False)
print(f"\nForecast complete! Rows: {len(results)}")
print("Output saved to: python/output/forecast_results.csv")