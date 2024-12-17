test_that("parse_assessment_data returns an opinionated named list of tibbles", {
  httptest2::with_mock_dir("assessment_742738", {
    red_list_api_key <- Sys.getenv("RED_LIST_API_KEY")
    api <- init_api(red_list_api_key)

    raw_assessment_result <- assessment_data(api, 742738)
    parsed_assessment_data <- parse_assessment_data(raw_assessment_result)

    expect_true(is.list(parsed_assessment_data))

    expected_names <- c(
      "assessment_date", "assessment_id", "assessment_points", "assessment_ranges",
      "biogeographical_realms", "citation", "conservation_actions",
      "conservation_actions_in_place", "credits", "criteria", "errata", "faos",
      "growth_forms", "habitats", "latest", "lmes", "locations", "population_trend",
      "possibly_extinct", "possibly_extinct_in_the_wild", "red_list_category",
      "references", "researches", "scopes", "sis_taxon_id", "stresses",
      "supplementary_info", "systems", "taxon", "taxon_common_names",
      "taxon_ssc_groups", "taxon_synonyms", "threats", "url", "use_and_trade",
      "year_published"
    )

    expect_equal(names(parsed_assessment_data), expected_names)

    expect_equal(parsed_assessment_data$assessment_date, dplyr::tibble(value = "2023-04-29T00:00:00.000Z"))
    expect_equal(parsed_assessment_data$assessment_id, dplyr::tibble(value = 742738))

    expect_equal(parsed_assessment_data$assessment_points, dplyr::tibble(value = FALSE))
    expect_equal(parsed_assessment_data$assessment_ranges, dplyr::tibble(value = FALSE))

    expect_equal(parsed_assessment_data$biogeographical_realms, dplyr::tibble(description = c("Palearctic"), code = c("7")))

    citation <- sub("Accessed on.*", "Accessed on", parsed_assessment_data$citation[1]$value)
    expect_equal(citation, "Parmakelis, A. 2023. Mastus unius. The IUCN Red List of Threatened Species 2023: e.T157079A742738. https://dx.doi.org/10.2305/IUCN.UK.2023-1.RLTS.T157079A742738.en. Accessed on")

    expect_equal(parsed_assessment_data$conservation_actions, dplyr::tibble())

    expected_credits <- dplyr::tibble(
      credit_type_name = c("assessor", "evaluator", "facilitators"),
      full = c("Parmakelis, A.", "Neubert, E., Seddon, M.B., Chelmis, N. & Karakasi, D.", "Pollock, C.M."),
      value = c("Aristeidis Parmakelis (University of Athens)", "Danae Karakasi (Natural History Museum of Crete, University of Crete, Greece)", "Caroline Pollock (IUCN Red List Unit)")
    )
    expect_equal(parsed_assessment_data$credits, expected_credits)

    expect_equal(parsed_assessment_data$criteria, dplyr::tibble())
    expect_equal(parsed_assessment_data$errata, dplyr::tibble())

    expect_equal(parsed_assessment_data$faos, dplyr::tibble())

    expect_equal(parsed_assessment_data$growth_forms, dplyr::tibble())

    expected_habitats <- dplyr::tibble(
      majorImportance = c(NA),
      season = c("Resident"),
      suitability = c("Suitable"),
      description = c("Shrubland - Temperate"),
      code = c("3_4")
    )
    expect_equal(parsed_assessment_data$habitats, expected_habitats)

    expect_equal(parsed_assessment_data$latest, dplyr::tibble(value = TRUE))
    expect_equal(parsed_assessment_data$lmes, dplyr::tibble())

    expect_locations <- dplyr::tibble(
      is_endemic = c(TRUE),
      formerlyBred = c(NA),
      origin = c("Native"),
      presence = c("Extant"),
      seasonality = c("Resident"),
      description = c("Greece"),
      code = c("GR")
    )
    expect_equal(parsed_assessment_data$locations, expect_locations)

    expected_population_trend <- dplyr::tibble(
      description = c("Unknown"),
      code = c("3")
    )

    expect_equal(parsed_assessment_data$population_trend, expected_population_trend)

    expect_equal(parsed_assessment_data$possibly_extinct, dplyr::tibble(value = FALSE))
    expect_equal(parsed_assessment_data$possibly_extinct_in_the_wild, dplyr::tibble(value = FALSE))

    expected_red_list_category <- dplyr::tibble(
      version = c("3.1"),
      description = c("Data Deficient"),
      code = c("DD")
    )
    expect_equal(parsed_assessment_data$red_list_category, expected_red_list_category)

    expect_length(parsed_assessment_data$references, 5)
    first_expected_references <- dplyr::tibble(
      citation = c("Legakis, A. and Maragkou, P. 2009. <i>The Red Data Book of the threatened species of Greece [in Greek]</i>. Hellenic Zoological Society, Athens."),
      year = c("2009"),
      title = c("The Red Data Book of the threatened species of Greece [in Greek]"),
      author = c("Legakis, A. and Maragkou, P."),
      citation_short = c("")
    )
    first_reference <- parsed_assessment_data$references %>% dplyr::slice(1)
    expect_equal(first_reference, first_expected_references)

    expected_researches <- dplyr::tibble(
      note = c("", "", ""),
      code = c("1_1", "1_2", "1_5"),
      description = c("Taxonomy", "Population size, distribution & trends", "Threats")
    )
    expect_equal(parsed_assessment_data$researches, expected_researches)

    expected_scopes <- dplyr::tibble(
      description = c("Global", "Europe", "Mediterranean"),
      code = c("1", "2", "4")
    )
    expect_equal(parsed_assessment_data$scopes, expected_scopes)

    expect_equal(parsed_assessment_data$sis_taxon_id, dplyr::tibble(value = c(157079)))
    expect_equal(parsed_assessment_data$stresses, dplyr::tibble())

    expected_supplementary_info <- dplyr::tibble(
      upper_elevation_limit = c(NA),
      lower_elevation_limit = c(NA),
      lower_depth_limit = c(NA),
      upper_depth_limit = c(NA),
      population_size = c(NA),
      population_severely_fragmented = c("No"),
      population_continuing_decline = c(NA),
      generational_length = c(NA),
      congregatory = c(NA),
      movement_patterns = c(NA),
      continuing_decline_in_area = c(NA),
      identification_information = c(NA),
      extreme_fluctuations = c(NA),
      no_of_subpopulations = c(NA),
      continuing_decline_in_subpopulations = c(NA),
      extreme_fluctuations_in_subpopulations = c(NA),
      all_individuals_in_one_subpopulation = c(NA),
      no_of_individuals_in_largest_subpopulation = c(NA),
      estimated_area_of_occupancy = c(NA),
      continuing_decline_in_area_of_occupancy = c(NA),
      extreme_fluctuations_in_area_of_occupancy = c(NA),
      estimated_extent_of_occurence = c(NA),
      continuing_decline_in_extent_of_occurence = c(NA),
      extreme_fluctuations_in_extent_of_occurence = c(NA),
      continuing_decline_in_number_of_locations = c(NA),
      extreme_fluctuations_in_number_of_locations = c(NA)
    )
    expect_equal(parsed_assessment_data$supplementary_info, expected_supplementary_info)

    expected_systems <- dplyr::tibble(
      description = c("Terrestrial"),
      code = c("0")
    )
    expect_equal(parsed_assessment_data$systems, expected_systems)

    expected_taxon <- dplyr::tibble(
      "sis_id" = c(157079),
      "scientific_name" = c("Mastus unius"),
      "kingdom_name" = c("ANIMALIA"),
      "phylum_name" = c("MOLLUSCA"),
      "class_name" = c("GASTROPODA"),
      "order_name" = c("STYLOMMATOPHORA"),
      "family_name" = c("ENIDAE"),
      "genus_name" = c("Mastus"),
      "species_name" = c("unius"),
      "subpopulation_name" = c(NA),
      "infra_name" = c(NA),
      "species" = c(TRUE),
      "subpopulation" = c(FALSE),
      "infrarank" = c(FALSE)
    )

    expect_equal(parsed_assessment_data$taxon, expected_taxon)

    expect_equal(parsed_assessment_data$taxon_common_names, dplyr::tibble())

    expected_taxon_ssc_groups <- dplyr::tibble(
      name = c("IUCN SSC Mollusc Specialist Group"),
      url = c("http://www.iucn.org/about/work/programmes/species/who_we_are/ssc_specialist_groups_and_red_list_authorities_directory/invertebrates/"),
    )
    expect_equal(parsed_assessment_data$taxon_ssc_groups$name, expected_taxon_ssc_groups$name)
    expect_equal(parsed_assessment_data$taxon_ssc_groups$url, expected_taxon_ssc_groups$url)


    expected_taxon_synonyms <- dplyr::tibble(
      name = c("Buliminus unius O. Boettger, 1885"),
      status = c("ACCEPTED"),
      genus_name = c("Buliminus"),
      species_name = c("unius"),
      species_author = c("O. Boettger, 1885"),
      infrarank_author = c(NA),
      subpopulation_name = c(NA),
      infra_type = c(NA),
      infra_name = c(NA)
    )
    expect_equal(parsed_assessment_data$taxon_synonyms, expected_taxon_synonyms)

    expect_equal(parsed_assessment_data$threats, dplyr::tibble())
    expect_equal(parsed_assessment_data$url, dplyr::tibble(value = "https://www.iucnredlist.org/species/157079/742738"))

    expect_equal(parsed_assessment_data$use_and_trade, dplyr::tibble())


    expect_equal(parsed_assessment_data$year_published, dplyr::tibble(value = "2023"))
  })
})
