import pandas as pd

file_path = r"C:\Users\SHREYOSHI\MYGITHUB PROJECTS\hces-sql-analysis\data\extracted\HCES_Data_2023-24_Csv\HCES_Data_2023-24_Csv\LEVEL - 05 ( Sec 5  6).csv"

df = pd.read_csv(file_path)

print("Shape:")
print(df.shape)

print("\nData types:")
print(df.dtypes)

print("\nColumns:")
print(df.columns.tolist())

print("\nFirst 5 rows:")
print(df.head())