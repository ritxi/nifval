# encoding: utf-8
# Adapted from http://compartecodigo.com/javascript/validar-nif-cif-nie-segun-ley-vigente-31.html

class NifValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || !Document.new(value).valid?
      record.errors.add(attribute, I18n.t("nifval.wrong"))
    end
  end

  private

  class Document
    attr_accessor :nif
    def initialize(nif)
      @nif = nif

      setup
    end

    def valid?
      case
      when invalid_format? then false
      when standard? then valid_standard?
      when special? then valid_special?
      when cif? then valid_cif?
      when nie? then valid_nie?
      else false
      end
    end

    def setup
      # Add zeros to the left if applyable, and accept lowercase
      @nif = nif.rjust(9,'0')
      nif.upcase!
    end
    private :setup

    def invalid_format?
      !nif.match(/^[A-Z]{1}\d{7}[A-Z0-9]{1}$/) && !nif.match(/^[0-9]{8}[A-Z]{1}$/)
    end

    def standard?
      !!nif.match(/^[0-9]{8}[A-Z]{1}$/)
    end

    def special?
      !!nif.match(/^[KLM]{1}/)
    end

    def cif?
      !!nif.match(/^[ABCDEFGHJNPQRSUVW]{1}/)
    end

    def nie?
      !!nif.match(/^[XYZ]{1}/)
    end

    def valid_cif?
      nstr = cif_algorithm_value.to_s
      (cif_last_number == cif_algorithm_value) || (cif_last_number == nstr[nstr.length-1])
    end

    def valid_nie?
      niff = nif.gsub("X","0").gsub("Y","1").gsub("Z","2")
      nif[8] == "TRWAGMYFPDXBNJZSQVHLCKE"[niff[0..7].to_i % 23]
    end

    def valid_special?
      nif[8] == (64+cif_algorithm_value).chr
    end

    def valid_standard?
      nif[8] == "TRWAGMYFPDXBNJZSQVHLCKE"[nif[0..7].to_i % 23]
    end

    def cif_algorithm_value
      @cif_algorithm_value ||= calculate_cif_algorithm_value
    end
    private :cif_algorithm_value

    def calculate_cif_algorithm_value
      # CIF algorithm
      sum = [nif[2], nif[4], nif[6]].map {|v| integer_value(v) }.sum
      [1,3,5,7].each do |i|
        t = (2*integer_value(nif[i])).to_s
        t1 = integer_value(t[0])
        t2 = t[1].nil? ? 0 : integer_value(t[1])
        sum += t1+t2
      end
      (10 - integer_value(sum.to_s[-1]))
    end
    private :calculate_cif_algorithm_value

    def cif_last_number
      if index = %w(A B C D E F G H I J).index(nif[8].upcase)
        index + 1
      end || integer_value(nif[8])
    end

    def integer_value v
      v.to_i
    end
    private :integer_value
  end
end
