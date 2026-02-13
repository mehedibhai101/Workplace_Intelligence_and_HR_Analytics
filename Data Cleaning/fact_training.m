let
    // Extracted the employee training records from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the employee training and development logs.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="fact_training.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 6-column schema.
    Imported_Training_Data = Csv.Document(File_Content,[Delimiter=",", Columns=6, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify program IDs, dates, and completion metrics.
    Promote_Headers = Table.PromoteHeaders(Imported_Training_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support ROI analysis and training frequency tracking.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"employee_id", Int64.Type}, 
        {"program_id", Int64.Type}, 
        {"training_date", type date}, 
        {"status", type text}, 
        {"score", Int64.Type}, 
        {"cost", Int64.Type}
    }),

    // Renamed headers to follow a professional, business-friendly convention for HR reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"employee_id", "Employee ID"}, 
        {"program_id", "Program ID"}, 
        {"training_date", "Training Date"}, 
        {"status", "Completion Status"}, 
        {"score", "Test Score"}, 
        {"cost", "Training Cost"}
    })
in
    Renamed_Columns
