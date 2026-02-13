let
    // Extracted the training program metadata from the local HR directory.
    Source_Folder = Folder.Files("C:\Users\perennial\OneDrive\Documents\_HR Analysis\Employee Data"),

    // Accessed the specific binary content for the training program dimension file.
    File_Content = Source_Folder{[#"Folder Path"="C:\Users\perennial\OneDrive\Documents\_HR Analysis\Employee Data\",Name="dim_training_programs.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 5-column schema.
    Imported_Training_Data = Csv.Document(File_Content,[Delimiter=",", Columns=5, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify program names and cost structures.
    Promote_Headers = Table.PromoteHeaders(Imported_Training_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to facilitate training investment analysis and relationship mapping.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"program_id", Int64.Type}, 
        {"program_name", type text}, 
        {"category", type text}, 
        {"provider", type text}, 
        {"cost_per_head", Int64.Type}
    }),

    // Renamed technical headers to professional labels for HR stakeholder reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"program_id", "Program ID"}, 
        {"program_name", "Program Name"}, 
        {"category", "Category"}, 
        {"provider", "Provider"}, 
        {"cost_per_head", "Cost Per Head"}
    })
in
    Renamed_Columns
