namespace :dev do
  images_path = Rails.root.join('public','system')

  desc "Executando o settup de desenvolvimento"
  task setup: :environment do
    puts "APAGANDO O BANCO DE DADOS.... #{%x(rake db:drop)}"
    if Rails.env.development?
      puts "Apagando imagens de public/system #{%x(rm -rf #{images_path})}"
    end
    puts "CRIANDO O BANCO DE DADOS.... #{%x(rake db:create)}"
    puts %x(rake db:migrate)
    puts %x(rake db:seed)
    puts %x(rake dev:generate_admin)
    puts %x(rake dev:generate_member)
    puts %x(rake dev:generate_ads)
    puts %x(rake dev:generate_comments)
  end
  desc "Settup de desenvolvimento Executado com Sucesso"

  ######################################

  desc "Cria Administradores fake"
  task generate_admin: :environment do
  	puts "Cadastrando ADMINISTRADOR padrão!"
  	10.times do
  		Admin.create!(
        name: Faker::Name.name,
  			email: Faker::Internet.email,
  			password: "123456",
  			password_confirmation: "123456",
        role: [0,0,1,1,1].sample
  			)
  	end
  	puts "ADMINISTRADORES cadastrados com sucesso"
  end

  ######################################

  desc "Cria Membros fake"
  task generate_member: :environment do
    puts "Cadastrando MEMBROS padrão!"
    100.times do
      member = Member.new(
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456"
        )

      member.build_profile_member
      member.profile_member.first_name = Faker::Name.first_name
      member.profile_member.second_name = Faker::Name.last_name
      member.save!
    end
    puts "MEMBROS cadastrados com sucesso"
  end

  ######################################

  desc "Cria Anúcios fake"
  task generate_ads: :environment do
    puts "Cadastrando de ANÚNCIOS"

    5.times do
      Ad.create!(
        title: Faker::Lorem.sentence([2,3,4,5].sample),
        description_markdown: Faker::Lorem.sentence([2,3].sample), #markdown_fake,
        description_short: Faker::Lorem.sentence([2,3].sample),
        member: Member.first,
        category: Category.all.sample,
        price: "#{Random.rand(500)},#{Random.rand(99)}",
        finish_date: Date.today + Random.rand(90),
        picture: File.new(Rails.root.join('public','images',"#{Random.rand(9)}.jpg"), 'r')
        )
    end

    # 100.times do
    #   Ad.create!(
    #     title: Faker::Lorem.sentence([2,3,4,5].sample),
    #     description_markdown: markdown_fake,
    #     description_short: Faker::Lorem.sentence([2,3].sample),
    #     member: Member.all.sample,
    #     category: Category.all.sample,
    #     price: "#{Random.rand(500)},#{Random.rand(99)}",
    #     finish_date: Date.today + Random.rand(90),
    #     picture: File.new(Rails.root.join('public','images',"#{Random.rand(9)}.jpg"), 'r')
    #     )
    # end
    puts "ANÚNCIOS cadastrados com sucesso"
  end

  def markdown_fake
    %x(ruby -e "require 'doctor_ipsum'; puts  DoctorIpsum::Markdown.entry")
  end

  desc "Cria COMENTÁRIOS fake"
  task generate_comments: :environment do
    puts "Criando COMENTÁRIOS"

    Ad.all.each do
      (Random.rand(3)).times do
        Comment.create!(
          body: Faker::Lorem.paragraph([2,3].sample),
          member: Member.all.sample,
          ad: Ad.all.sample
        )
      end
    end
    puts "COMENTÁRIOS cadastrados com sucesso"
  end

end
