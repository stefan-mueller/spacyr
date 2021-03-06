context("test spacy_initialize")

test_that("spacy_initialize() with non-existent python (#49)", {
    expect_error(
        spacy_initialize(python_executable = "/usr/local/bin/notpython"),
        "notpython is not a python executable"
    )
})
