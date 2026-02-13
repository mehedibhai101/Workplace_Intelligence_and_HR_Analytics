let
    // Extracted the employee leave records from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the leave fact file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="fact_leave.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 5-column schema.
    Imported_Leave_Data = Csv.Document(File_Content,[Delimiter=",", Columns=5, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify leave types, dates, and durations.
    Promote_Headers = Table.PromoteHeaders(Imported_Leave_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support duration calculations and relationship mapping.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"employee_id", Int64.Type}, 
        {"type", type text}, 
        {"start", type date}, 
        {"days", Int64.Type}, 
        {"status", type text}
    }),

    // Filtered records to include only leave instances starting from the year 2020 onwards.
    Filter_By_Date_Range = Table.SelectRows(Set_Data_Types, each [start] > #date(2019, 12, 31)),

    // Renamed technical headers to professional labels for reporting clarity.
    Renamed_Columns = Table.RenameColumns(Filter_By_Date_Range,{
        {"employee_id", "Employee ID"}, 
        {"type", "Leave Type"}, 
        {"start", "Start Date"}, 
        {"days", "Leave Duration"}, 
        {"status", "Approval Status"}
    })
in
    Renamed_Columns
