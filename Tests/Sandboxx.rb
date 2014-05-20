require 'rspec'
require_relative '../Classes/Perro.rb'
require_relative '../Metabuilder/Metabuilder.rb'

describe 'Creacion de Metabuilder' do

  it 'deberia correr este hermoso test basico' do
    builder_de_perros = Metabuilder.new
    .set_target_class(Perro)
    .add_property(:raza)
    .add_property(:edad)
    .add_property(:peso)
    .build

    ###--------------------------------------------
    builder_de_perros.raza = 'Fox Terrier'
    builder_de_perros.edad = 4
    builder_de_perros.peso = 14
    perro = builder_de_perros.build

    ###--------------------------------------------
    perro.raza.should == 'Fox Terrier'
    perro.edad.should == 4
    perro.peso.should == 14
  end

  it 'deberia correr con sintaxis nueva' do
    builder_de_perros = Metabuilder.build {
      target_class(Perro)
      property(:raza)
      property(:edad)
      property(:peso)
    }

    ###--------------------------------------------
    builder_de_perros.raza = 'Fox Terrier'
    builder_de_perros.edad = 4
    builder_de_perros.peso = 14
    perro = builder_de_perros.build

    ###--------------------------------------------
    perro.raza.should == 'Fox Terrier'
    perro.edad.should == 4
    perro.peso.should == 14
  end

  it 'deberia correr con sintaxis nueva y NO cachear excepcion' do
      builder_de_perros = Metabuilder.build {
        target_class(Perro)
        property(:raza)
        property(:edad)
        property(:peso)
        validate{
          edad > 0
        }
      }

    ###--------------------------------------------
    builder_de_perros.raza = 'Fox Terrier'
    builder_de_perros.edad = 4
    builder_de_perros.peso = 14
    perro = builder_de_perros.build

    ###--------------------------------------------
    perro.raza.should == 'Fox Terrier'
    perro.edad.should == 4
    perro.peso.should == 14
  end

  it 'deberia correr con sintaxis nueva y cachear excepcion' do

      builder_de_perros = Metabuilder.build {
        target_class(Perro)
        property(:raza)
        property(:edad)
        property(:peso)
        validate{
          edad < 0
        }
      }

    ###--------------------------------------------
    builder_de_perros.raza = 'Fox Terrier'
    builder_de_perros.edad = 4
    builder_de_perros.peso = 14
    expect{
      builder_de_perros.build
    }.to raise_error(Exception)
  end

  it 'deberia correr con comportamiento' do

    builder_de_perros = Metabuilder.build {
      target_class(Perro)
      property(:raza)
      property(:edad)
      property(:peso)
      behave_when :edad, proc {raza == 'Fox Terrier'}, proc {5}
      behave_when :edad_limite, proc {raza == 'Fox Terrier'}, proc {15}
    }

    ###--------------------------------------------
    builder_de_perros.raza = 'Fox Terrier'
    builder_de_perros.edad = 4
    builder_de_perros.peso = 14
    perro =builder_de_perros.build
    ##---------------------------------------------
    perro.raza.should == 'Fox Terrier'
    perro.edad.should == 5
    perro.peso.should == 14
    perro.edad_limite.should == 15
  end
end