let
    // Extracted the employee salary history from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the historical salary adjustments.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="fact_salary.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 4-column schema.
    Imported_Salary_Data = Csv.Document(File_Content,[Delimiter=",", Columns=4, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify employee IDs, dates, and pay amounts.
    Promote_Headers = Table.PromoteHeaders(Imported_Salary_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to facilitate time-series compensation analysis.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"employee_id", Int64.Type}, 
        {"effective_date", type date}, 
        {"salary", Int64.Type}, 
        {"reason", type text}
    }),

    // Renamed headers to follow a professional, business-friendly convention.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"employee_id", "Employee ID"}, 
        {"effective_date", "Effective Date"}, 
        {"salary", "Annual Salary"}, 
        {"reason", "Change Reason"}
    })
in
    Renamed_Columns
