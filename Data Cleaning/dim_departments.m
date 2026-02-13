let
    // Extracted the department data from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the department lookup file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="dim_departments.csv"]}[Content],

    // Imported the CSV document with the correct encoding and schema.
    Imported_Dept_Data = Csv.Document(File_Content,[Delimiter=",", Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify department IDs and focus areas.
    Promote_Headers = Table.PromoteHeaders(Imported_Dept_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to ensure integrity during HR data modeling.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{{"dept_id", Int64.Type}, {"dept_name", type text}, {"focus", type text}}),

    // Simplified department naming for cleaner visualization and stakeholder reporting.
    Apply_Value_Replacements = Table.ReplaceValue(Set_Data_Types,"Production / Manufacturing","Production",Replacer.ReplaceText,{"dept_name"}),

    // Renamed columns to follow a clean, professional naming convention.
    Renamed_Columns = Table.RenameColumns(Apply_Value_Replacements,{
        {"dept_id", "Department ID"}, 
        {"dept_name", "Department"}, 
        {"focus", "Focus Area"}
    })
in
    Renamed_Columns
