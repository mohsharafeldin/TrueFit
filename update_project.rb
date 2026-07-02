require 'xcodeproj'

project_path = 'TrueFit.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Remove old file
old_file_path = 'TrueFit/Packages/Features/Shared/ViewState.swift'
old_file_ref = project.main_group.find_file_by_path(old_file_path)
if old_file_ref
    target.source_build_phase.remove_file_reference(old_file_ref)
    old_file_ref.remove_from_project
end

# Add new files
files_to_add = [
    'TrueFit/Packages/Domain/Entities/AppError.swift',
    'TrueFit/Packages/Core/Utilities/ErrorLogger.swift',
    'TrueFit/Packages/Core/Utilities/ViewState.swift',
    'TrueFit/Packages/Data/Mappers/APIErrorMapper.swift',
    'TrueFit/Packages/Data/Mappers/GenericAPIErrorMapper.swift',
    'TrueFit/Packages/Features/Shared/Views/ErrorView.swift'
]

files_to_add.each do |file_path|
    dir = File.dirname(file_path)
    base = File.basename(file_path)
    
    group = project.main_group.find_subpath(dir, true)
    group.set_source_tree('<group>')
    
    file_ref = group.files.find { |f| f.path == base || f.name == base }
    unless file_ref
        file_ref = group.new_reference(base)
    end
    
    target.add_file_references([file_ref])
end

project.save
puts "Project updated successfully!"
