module OrderBundleOptions

  OPTIONS = {
    upinfo: "https://rencontredejeunesse.ch",
    subtitle3: "À présenter le jour de l'événement",
    dates: "03.05.-05.05.2018",
    times: "17:00/16:00",
    loc1: "Espace-Gruyère",
    loc2: "Rue de Vevey 64",
    loc3: "1630 Bulle",
    loc4: "Suisse",
    orga1: "Association Rencontre de Jeunesse",
    orga2: "1607 Palézieux",
    orga3: "Suisse",
    orga4: "www.rencontredejeunesse.ch",
    sub1_code: "#rjbulle19",
    contact: "info@rencontredejeunesse.ch"
  }
end

OrderBundle.create!(name: "RJ Login 19", description: "Une journée qui réunit les leaders de Suisse romande", order_type_id: 1, options: 