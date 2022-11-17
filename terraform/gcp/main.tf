provider "google" {
  project = "project-uat2"
  region  = "asia-northeast3"
  zone    = "asia-northeast3-a"
}

module "gb-uat2" {
  source = "./modules/uat2"

  dataPath           = "data.json"
  diskType           = "pd-balanced"
  snapshotPath       = "projects/projects-prod/global/snapshots"
  subnetwork_project = "projects-uat2"
}
