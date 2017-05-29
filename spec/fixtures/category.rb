HydraAttribute::Migrator.new(ActiveRecord::Base.connection).create :categories do |t|
  t.string :name
  t.timestamps null: false
end

class Category < ActiveRecord::Base
  include HydraAttribute::ActiveRecord
end
