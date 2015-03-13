class OrderProductSerializer < ProductSerializer
  attributes :id

  def include_user?
    false
  end
end
