namespace :dev do
  desc "Reset the database"
  task reset: :environment do
    system("rails db:drop")
    system("rails db:create")
    system("rails db:migrate")
    system("rails db:seed")
    system("rails dev:add_units")
    system("rails dev:add_departments")
    system("rails dev:add_positions")
    system("rails dev:add_employees")
  end

  desc "Add units to the database"
  task add_units: :environment do
    show_spinner("Adding units to the database") { add_units }
  end

  desc "Add departments to the database"
  task add_departments: :environment do
    show_spinner("Adding departments to the database") { add_departments }
  end

  desc "Add positions to the database"
  task add_positions: :environment do
    show_spinner("Adding positions to the database") { add_positions }
  end

  desc "Add employees to the database"
  task add_employees: :environment do
    show_spinner("Adding employees to the database") { add_employees }
  end

  def add_units
    [ "Unidade Matriz", "Unidade Fabril", "Centro de Distribuição", "Unidade de Inovação",
      "Polo Industrial", "Unidade de Beneficiamento", "Centro de Serviços Compartilhados",
      "Escritório Regional", "Unidade de Manutenção", "Centro de Treinamento" ].each do |unidade|
      Unit.create!(
        name: unidade,
        description: Faker::Lorem.paragraph(sentence_count: rand(3..5)),
        active: true
      )
    end
  end

  def add_departments
    departments = [ "Engenharia", "Produção", "Qualidade", "Manutenção", "Logística", "Compras", "Vendas", "Marketing", "Financeiro",
      "Recursos Humanos", "TI", "Segurança", "P&D", "Jurídico", "Compliance", "Planejamento", "Contabilidade",
      "Controladoria", "Fiscal", "Suprimentos", "Almoxarifado", "Expedição", "Embalagem", "Processos", "Automação",
      "Saúde e Segurança", "Meio Ambiente", "Treinamento", "Auditoria", "Comunicação",
      "Projetos", "Inovação", "Melhoria Contínua", "Estratégia", "Custos", "Facilities", "Frota", "Serviços Gerais",
      "Importação", "Exportação", "Engenharia de Produto", "Engenharia de Processos", "Engenharia de Manutenção",
      "Engenharia de Qualidade", "Engenharia de Automação", "Manufatura", "Usinagem", "Montagem", "Acabamento",
      "Teste"]

      departments.each do |name|
        department = Department.create!(
          name: name,
          description: Faker::Lorem.paragraph(sentence_count: rand(3..5)),
          active: true
        )

        # Seleciona unidades aleatórias e cria as associações
        unit_ids = Unit.pluck(:id).sample(rand(1..Unit.count)) # Pelo menos 1 unidade
        unit_ids.each do |unit_id|
          UnitDepartment.create!(unit_id: unit_id, department_id: department.id)
        end
      end
  end

  def add_positions
    [ "Gerente de Produção", "Engenheiro de Processos", "Analista de Qualidade", "Supervisor de Manutenção", "Coordenador de Logística",
      "Técnico em Automação", "Operador de Máquinas CNC", "Inspetor de Qualidade", "Mecânico Industrial", "Eletricista Industrial",
      "Engenheiro de Segurança do Trabalho", "Técnico em Segurança do Trabalho", "Analista de Meio Ambiente",
      "Coordenador de Saúde e Segurança", "Enfermeiro do Trabalho", "Gerente de Compras", "Analista de Suprimentos",
      "Comprador Técnico", "Almoxarife", "Controlador de Estoque", "Gerente de Recursos Humanos", "Analista de RH",
      "Recrutador", "Treinador", "Analista de Folha de Pagamento", "Gerente Financeiro", "Analista Financeiro", "Contador",
      "Tesoureiro", "Auditor Interno", "Engenheiro de Projetos", "Desenhista Projetista", "Analista de Custos", "Planejador de Projetos",
      "Técnico em Edificações", "Gerente de Vendas", "Representante Comercial", "Analista de Marketing", "Técnico em Marketing",
      "Atendente de Vendas", "Gerente de TI", "Analista de Sistemas", "Técnico em Informática", "Administrador de Banco de Dados",
      "Programador", "Diretor Industrial", "Consultor Industrial", "Engenheiro de Produção Sênior", "Especialista em Lean Manufacturing",
      "Analista de Melhoria Contínua"].each do |name|

      Position.create!(
        name: name,
        description: Faker::Lorem.paragraph(sentence_count: rand(3..5)),
        active: true
      )
    end
  end

  def add_employees
    100.times do
      unit = Unit.order("RANDOM()").first
      department = unit.departments.order("RANDOM()").first
      position = Position.order("RANDOM()").first
      name = Faker::Name.name
      first_name = name.split.first.parameterize
      last_name = name.split.last.parameterize
      email = "#{first_name}.#{last_name}@#{unit.name.downcase.gsub(/ /, '').tr(
        'àáâãäåçèéêëìíîïñòóôõöùúûüýÿ',
        'aaaaaaceeeeiiiinooooouuuuyy'
      )}.com"
      Employee.create!(
        name: name,
        email: email,
        unit_id: unit.id,
        department_id: department.id,
        position_id: position.id,
        active: true
      )
    end
  end

  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

end
