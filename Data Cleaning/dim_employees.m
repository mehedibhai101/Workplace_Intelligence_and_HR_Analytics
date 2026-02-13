let
    // Extracted the employee master data from the local HR directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the employee dimension file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="dim_employees.csv"]}[Content],

    // Imported the CSV document with the correct encoding and 28-column schema.
    Imported_Employee_Data = Csv.Document(File_Content,[Delimiter=",", Columns=28, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers for proper field identification.
    Promote_Headers = Table.PromoteHeaders(Imported_Employee_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types including Date of Birth (dob) and key IDs.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"employee_id", Int64.Type}, {"user_id", type text}, {"name", type text}, {"gender", type text}, 
        {"blood_group", type text}, {"marital_status", type text}, {"national_id", Int64.Type}, 
        {"tin_number", Int64.Type}, {"phone_number", Int64.Type}, {"personal_email", type text}, 
        {"work_email", type text}, {"present_address", type text}, {"permanent_address", type text}, 
        {"university", type text}, {"degree", type text}, {"cgpa", type number}, {"dept_id", Int64.Type}, 
        {"job_id", Int64.Type}, {"job_title", type text}, {"job_level", Int64.Type}, {"work_mode", type text}, 
        {"joining_date", type date}, {"status", type text}, {"exit_date", type date}, {"exit_reason", type text}, 
        {"current_salary", Int64.Type}, {"manager_id", Int64.Type}, {"dob", type date}
    }),

    // Transformed the present address to extract District and Division details.
    Process_Present_Address = let
        Extract_District_Division = Table.TransformColumns(Set_Data_Types, {{"present_address", each Text.AfterDelimiter(_, ", ", 1), type text}}),
        Split_Address_Column = Table.SplitColumn(Extract_District_Division, "present_address", Splitter.SplitTextByEachDelimiter({", "}, QuoteStyle.Csv, true), {"district", "division"})
    in
        Table.TransformColumnTypes(Split_Address_Column,{{"district", type text}, {"division", type text}}),

    // Cleaned the permanent address field by extracting text after the final delimiter.
    Format_Permanent_Address = Table.TransformColumns(Process_Present_Address, {{"permanent_address", each Text.AfterDelimiter(_, ": ", {0, RelativePosition.FromEnd}), type text}}),

    // Removed PII and irrelevant academic columns to optimize the dataset for HR analysis.
    Remove_Unnecessary_Columns = Table.RemoveColumns(Format_Permanent_Address, {
        "blood_group", "national_id", "tin_number", "phone_number", 
        "personal_email", "work_email", "university", "cgpa"
    }),

    // Renamed technical headers to professional, business-friendly labels.
    Renamed_Final_Columns = Table.RenameColumns(Remove_Unnecessary_Columns, {
        {"employee_id", "Employee ID"}, {"user_id", "User ID"}, {"name", "Employee Name"}, 
        {"gender", "Gender"}, {"marital_status", "Marital Status"}, {"dept_id", "Department ID"}, 
        {"job_id", "Job ID"}, {"job_title", "Job Title"}, {"job_level", "Job Level"}, 
        {"work_mode", "Work Mode"}, {"joining_date", "Joining Date"}, {"status", "Employment Status"}, 
        {"exit_date", "Exit Date"}, {"exit_reason", "Exit Reason"}, {"current_salary", "Current Salary"}, 
        {"manager_id", "Manager ID"}, {"dob", "Date of Birth"}, {"district", "District"}, {"division", "Division"}
    })
in
    Renamed_Final_Columns
