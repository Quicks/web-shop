require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	
	fixtures :products

	def new_product(image_url)
		Product.new(title: "gardemarini vpered",
			description: "movie",
			price: 1,
			image_url: image_url)
	end
	
	test "image url" do

		ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
			http://a.b.c/x/y/z/fred.gif }
		
		bad = %w{ fred.doc fred.gif/more fred.gif.more }
		
		ok.each do |name|
			assert new_product(name).valid?, "#{name} shouldn't be invalid"
		end
		
		bad.each do |name|
			assert new_product(name).invalid?, "#{name} shouldn't be valid"
	end	
	end

	test "product attributes must not be empty" do
	  	# свойства товара не должны оставаться пустыми
	  	product = Product.new

	  	assert product.invalid?
	  	assert product.errors[:title].any?
	  	assert product.errors[:description].any?
	  	assert product.errors[:image_url].any?
	  	assert product.errors[:price].any?
	end

  	test "product price must be positive" do
  		product = Product.new(title: "Jandarm vpered",
  							description: "lui",
  							image_url: "ruby.jpg")
  		product.price = -1
  		assert product.invalid?
  		assert_equal ["must be greater than 0.01"],
  		product.errors[:price]
  		product.price = 0

  		assert product.invalid?
  		assert_equal ["must be greater than or equal to 0.01"],
  		product.errors[:price]
  		product.price = 1

  		assert product.valid?
  	end

  	test "product must have unique title" do
  		product = Product.new(title: products(:ruby).title,
  							description: "dsadsadsadasdsad",
  							price: 2,
  							image_url: "tree.gif")

  		assert product.invalid?
  		assert_equal ["must have unique title"],product.errors[:title]

  	end		

  	test "product mast have unique title in i18" do
  		product = Product.new(title: products(:ruby).title,
  			description: "dsadadaas",
  			price: 3,
  			image_url: "binary.png")

  		assert product.invalid?
  		assert_equal [I18n.translate('activerecord.errors.messages.taken')],product.errors[:title]
  	end		



end
