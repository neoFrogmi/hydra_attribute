HydraAttribute::Migrator.new(ActiveRecord::Base.connection).create :products do |t|
  t.string :name
  t.timestamps null: false
end

class Product < ActiveRecord::Base
  include HydraAttribute::ActiveRecord
end
