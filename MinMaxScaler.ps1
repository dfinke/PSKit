function MinMaxScaler {
    param(
        $targetData,
        $propertyNames,
        $ThrottleLimit
    )
    
    $propertyNames | ForEach-Object -Parallel {

        $minMax = ($using:targetData).$_ | Measure-Object -Maximum -Minimum 
        $min = $minMax.Minimum
        $max = $minMax.Maximum
        $denominator = $max - $min
        
        [PSCustomObject][ordered]@{
            PropertyName   = $_
            Minimum        = $min
            Maximum        = $max
            NormalizedData = foreach ($x in ($using:targetData).$_) { ($x - $min) / $denominator }    
        }
    }    
}

function dotransform {
    param(
        $targetData,
        $propertyNames
    )

    foreach ($row in $targetData) {
        foreach ($item in $row.NormalizedData) {
            [PSCustomObject][Ordered]@{Feature = $Row.PropertyName ; Measure = $item }
        }
    }
}

$data = read-csv 'D:\temp\scratch\Artificial-Intelligence-in-3-hours-\data.csv'

$p = $(
    'radius_mean'
    'texture_mean'
    'perimeter_mean'
    'area_mean'
    'smoothness_mean'
    'compactness_mean'
    'concavity_mean'
    'concave points_mean'
    'symmetry_mean'
    'fractal_dimension_mean'
    'radius_se'
    'texture_se'
    'perimeter_se'
    'area_se'
    'smoothness_se'
    'compactness_se'
    'concavity_se'
    'concave points_se'
    'symmetry_se'
    'fractal_dimension_se'
    'radius_worst'
    'texture_worst'
    'perimeter_worst'
    'area_worst'
    'smoothness_worst'
    'compactness_worst'
    'concavity_worst'
    'concave points_worst'
    'symmetry_worst'
    'fractal_dimension_worst'
)

$params = @{
    InputObject          = (dotransform (MinMaxScaler $data $p) $p) 
    AutoNameRange        = $true
    ExcelChartDefinition = New-ExcelChart -XRange Feature -YRange Measure -ChartType XYScatter
}

Export-Excel @params