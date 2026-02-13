let
    // Extracted the daily attendance logs from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the attendance fact file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="fact_attendance.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 3-column schema.
    Imported_Attendance_Data = Csv.Document(File_Content,[Delimiter=",", Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify dates, employees, and presence status.
    Promote_Headers = Table.PromoteHeaders(Imported_Attendance_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support time-intelligence and relationship mapping.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"date", type date}, 
        {"employee_id", Int64.Type}, 
        {"status", type text}
    }),

    // Renamed headers to follow a professional, business-friendly convention.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"date", "Date"}, 
        {"employee_id", "Employee ID"}, 
        {"status", "Attendance Status"}
    })
in
    Renamed_Columns
