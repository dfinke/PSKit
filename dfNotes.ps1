cls
ipmo .\PSKit.psd1 -Force

# https://pandas.pydata.org/pandas-docs/stable/getting_started/10min.html

<#
DataFrame(
    data=None,
    index: Optional[Collection] = None,
    columns: Optional[Collection] = None,
    dtype: Union[str, numpy.dtype, ExtensionDtype, None] = None, 
    copy: bool = False
)

data ndarray (structured or homogeneous), Iterable, dict, or DataFrame
    Dict can contain Series, arrays, constants, or list-like objects

indexIndex or array-like
    Index to use for resulting frame. Will default to RangeIndex if no indexing information part of input data and no index provided.

columnsIndex or array-like
    Column labels to use for resulting frame. Will default to RangeIndex (0, 1, 2, …, n) if no column labels are provided.
#>

df @{
    a=(2,1,4)
    b=(3,5,0)
}

return 

df (1, 2, 3), (4, 5, 6), (7, 8, 9) -columns 'a', 'b', 'c' | gm

return 

$d = [ordered]@{'col1'=1, 2; 'col2'= 3, 4}

$df = df $d 

$df | Out-String
$df.dtypes() | Out-String