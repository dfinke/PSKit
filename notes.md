# Pandas

## Pandas Data Structures

### Series

Series is a one-dimensional labeled array capable of holding data of any type (integer, string, float, python objects, etc.). The axis labels are collectively called index.

- https://www.tutorialspoint.com/python_pandas/python_pandas_series.htm

- https://learning.oreilly.com/library/view/pandas-for-everyone/9780134547046/ch02.xhtml#ch02


```python
pd.Series(['Wes McKinney', 'Creator of Pandas'],
    index=['Person', 'Who'])
```

```
Person         Wes McKinney
Who       Creator of Pandas
dtype: object
```