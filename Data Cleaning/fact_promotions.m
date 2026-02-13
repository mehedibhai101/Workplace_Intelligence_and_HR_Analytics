let
    // Extracted the employee promotion history from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the promotion records.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="fact_promotions.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 6-column schema.
    Imported_Promotion_Data = Csv.Document(File_Content,[Delimiter=",", Columns=6, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify job changes, dates, and salary adjustments.
    Promote_Headers = Table.PromoteHeaders(Imported_Promotion_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support career progression and compensation analysis.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"employee_id", Int64.Type}, 
        {"old_job", Int64.Type}, 
        {"new_job", Int64.Type}, 
        {"prom_date", type date}, 
        {"old_sal", Int64.Type}, 
        {"new_sal", Int64.Type}
    }),

    // Renamed headers to follow a professional, business-friendly convention for HR stakeholders.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"employee_id", "Employee ID"}, 
        {"old_job", "Old Job ID"}, 
        {"new_job", "New Job ID"}, 
        {"prom_date", "Promotion Date"}, 
        {"old_sal", "Previous Salary"}, 
        {"new_sal", "New Salary"}
    })
in
    Renamed_Columns
