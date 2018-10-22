package org.apache.spark.deploy.pbs

import scala.util.matching.Regex
import org.apache.spark.pbs.Utils

private[pbs] case class PbsDriverInfo(jobId: String) {
  var jobName: String = null
  var user: String = null
  var submissionDate: String = null
  var ncpus: String = null
  var mem: String = null
  var state: String = null

  val ROW_REGEX: Regex = """(.*) = (.*)"""r
  val JOB_REGEX: Regex = """sparkjob-(.*)"""r

  init()

  def init() {
    Utils.qstat(jobId, "-f").split("\n").foreach(jobRow => {
      try {
        val ROW_REGEX(key, value) = jobRow
        key.trim() match {
          case "Job_Name" =>
            val JOB_REGEX(className) = value.trim()
            jobName = className
          case "Job_Owner" =>
            user = value.trim()
          case "Resource_List.ncpus" =>
            ncpus = value
          case "Resource_List.mem" =>
            mem = value
          case "qtime" =>
            submissionDate = value
          case "job_state" =>
            state = value
          case _ =>  // ignored (for now)
        }
      } catch {
        case e: scala.MatchError => // TODO: Split lines end up here. Fix them.
      }
    })
  }

  val isRunning: Boolean = { state == "R" }
  val isQueued: Boolean = { state == "Q" }
  val isCompleted: Boolean = { state == "C" } // TODO: This is incorrect.
}

private[pbs] object PbsDriverInfo {
  val SPARK_JOB_REGEX: Regex  = """([0-9]+\.[a-z]+) +(sparkjob-[a-zA-Z\-\.]*.*)"""r

  def create(jobString: String): PbsDriverInfo = {
    jobString match {
      case SPARK_JOB_REGEX(job, _) =>  // job is a spark job
        PbsDriverInfo(job)
      case _ =>
        null
    }
  }
}
