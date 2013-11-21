class Nif
  attr_accessor :testfield

  include ActiveModel::Validations


  validates :testfield, nif: true
end