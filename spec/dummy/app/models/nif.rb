class Nif < ActiveRecord::Base
  include ActiveModel::Validations

  validates :testfield, nif: true

  attr_accessor :testfields

  def initialize testfield
    @testfield = testfield
  end
end