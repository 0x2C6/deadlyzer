# module Support
#   module ConstantCode
#     USER_CLASS = <<~RUBY
#       class User
#         attr_accessor :firstname, :lastname
        
#         def initialize(firstname, lastname)
#           @firstname = first
#           @lastname  = lastname
#         end

#         def id_number
#           id_service.call(@firstname, @lastname)
#         end

#         private
#         def id_service
#           IDNumberService.new
#         end
#       end
#     RUBY
#   end
# end