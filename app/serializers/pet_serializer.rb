class PetSerializer < ActiveModel::Serializer
  attributes :id, :name, :birth_date

  def birth_date
    object.birth_date ? object.birth_date.strftime('%F') : nil
  end
end
