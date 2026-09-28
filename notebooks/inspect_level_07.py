import pandas as pd

file_path = r"C:\Users\SHREYOSHI\MYGITHUB PROJECTS\hces-sql-analysis\data\extracted\HCES_Data_2023-24_Csv\HCES_Data_2023-24_Csv\LEVEL - 07 (Section 4_2).csv"

df = pd.read_csv(file_path)

print(df.shape)
print(df.dtypes)

print("\nColumns:")
print(df.columns.tolist())

print("\nFirst 5 rows:")
print(df.head())

import pandas as pd

file_path = r"C:\Users\SHREYOSHI\MYGITHUB PROJECTS\hces-sql-analysis\data\extracted\HCES_Data_2023-24_Csv\HCES_Data_2023-24_Csv\LEVEL - 11 (Section 4_3).csv"

df = pd.read_csv(file_path)

print(df.shape)
print(df.dtypes)

print("\nColumns:")
print(df.columns.tolist())

print("\nFirst 5 rows:")
print(df.head())