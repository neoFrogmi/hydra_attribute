HydraAttribute::Migrator.new(ActiveRecord::Base.connection).create :flats do |t|
  t.integer :number
  t.timestamps null: false
end

class Flat < ActiveRecord::Base
  include HydraAttribute::ActiveRecord

  has_many :rooms, dependent: :destroy
end
