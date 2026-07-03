require 'xcodeproj'

project_path = 'TrueFit.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

files_to_add = [
    'TrueFit/Packages/Core/Networking/Shared/GenericEndpoint.swift',
    'TrueFit/Packages/Core/Networking/Shared/GenericAPIError.swift',
    'TrueFit/Packages/Core/Networking/Shared/GenericHTTPClientProtocol.swift',
    'TrueFit/Packages/Core/Networking/Shared/GenericHTTPClient.swift',
    'TrueFit/Packages/Core/Networking/Frankfurter/GetLatestRatesEndpoint.swift',
    'TrueFit/Packages/Data/DTOs/CurrencyRatesDTO.swift',
    'TrueFit/Packages/Data/Mappers/CurrencyRatesMapper.swift',
    'TrueFit/Packages/Data/DataSources/Remote/CurrencyRemoteDataSource.swift',
    'TrueFit/Packages/Data/Repositories/CurrencyRepository.swift',
    'TrueFit/Packages/Domain/Entities/CurrencyRates.swift',
    'TrueFit/Packages/Domain/RepositoryInterfaces/CurrencyRepositoryProtocol.swift',
    'TrueFit/Packages/Domain/UseCases/GetExchangeRatesUseCase.swift',
    'TrueFit/Packages/Features/CurrencyConversion/CurrencyConverterViewModel.swift'
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
puts "Files added successfully!"
