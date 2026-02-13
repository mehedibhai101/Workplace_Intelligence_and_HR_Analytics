let
    // Extracted the employee performance records from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the annual performance ratings.
    File_Content = Source_Folder{[#"your_folder_path\",Name="fact_performance.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 3-column schema.
    Imported_Performance_Data = Csv.Document(File_Content,[Delimiter=",", Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify employees, review years, and scores.
    Promote_Headers = Table.PromoteHeaders(Imported_Performance_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support year-over-year growth calculations.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"employee_id", Int64.Type}, 
        {"year", Int64.Type}, 
        {"rating", Int64.Type}
    }),

    // Renamed technical headers to professional labels for management reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"employee_id", "Employee ID"}, 
        {"year", "Review Year"}, 
        {"rating", "Performance Rating"}
    })
in
    Renamed_Columns
