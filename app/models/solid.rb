class Solid < Feeding

  # TODO Update How many grams in each container
  CONTAINER_SIZE_MAPPING = {
    /small container|mash|lamb brocoli/ => 15,
    /medium container/ => 30,
    /container/        => 50,

    /bowl|porridge|farrax|farex/ => 300,
    /egg pear/                   => 150, # 1/2 bowl

    /piece|slice|sclice|toast|トスト/ => 100,

    /jar/       => 100,
    /spoon/     => 5,
    /teaspoon/  => 5,

    /cracker/   => 5,

    /pouch|puree|and apple|and mango|chicken bolognese/ => 110,
  }

  # Infers and sets the 'amount' from the quantity and description
  # i.e 1/2 Bowl Banana Porridge", "1 Slice Almond Toast", "1 Sweet Pouch", "1 Small Container Lamb Mash" ...
  #
  def infer_amount!
    self.amount = nil

    if quantity.present? && quantity.downcase.include?('grams')
      self.amount = quantity.gsub('grams', '').to_i
      return
    end

    full_description = "#{quantity.try(:singularize)} #{description.try(:singularize)}".downcase

    CONTAINER_SIZE_MAPPING.each do |container, grams|
      if full_description.match(container)
        # Call ''.to_r on each segment, utilising the fact that 'and'.to_r.to_f => 0.0
        proportion = full_description.split(' ').map(&:to_r).sum

        if proportion
          self.amount = proportion * grams
          # puts "Translated #{full_description} => #{proportion.to_f} * #{container} => #{amount.to_f}g"
          break
        end

      end
    end

    if self.amount == nil
      puts "WARNING: Didn't find match for [#{full_description}]"
    end
  end

end
