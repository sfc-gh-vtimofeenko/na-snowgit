-- Account level, needs account-wide permissions
-- IF NOT EXISTS so as not to break other objects that use this API integration
CREATE API INTEGRATION IF NOT EXISTS sfc_gh_vtimofeenko_public

    API_PROVIDER=git_https_api
    API_ALLOWED_PREFIXES=('https://github.com/sfc-gh-vtimofeenko')
    COMMENT = 'API integration to be used by Snowflake git repository integrations'
    enabled = true;

CREATE OR REPLACE DATABASE na_snowgit;

-- For read-only access to git this is fine
CREATE OR REPLACE GIT REPOSITORY na_snowgit.public.na_snowgit_repo
    api_integration =  sfc_gh_vtimofeenko_public
    origin = "https://github.com/sfc-gh-vtimofeenko/na-snowgit";

