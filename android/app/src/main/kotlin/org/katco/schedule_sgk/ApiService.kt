package org.katco.schedule_sgk

import okhttp3.OkHttpClient
import okhttp3.Request
import org.katco.schedule_sgk.model.Lesson
import org.json.JSONArray
import org.json.JSONObject
import java.io.IOException

class ApiService {

    private val client = OkHttpClient()

    fun getGroupSchedule(groupKey: String, date: String): List<Lesson> {
        val url = "https://asu.samgk.ru/api/schedule/$groupKey/$date"
        val response = fetchData(url)
        return parseResponse(response)
    }

    fun getTeacherSchedule(teacherKey: String, date: String): List<Lesson> {
        val url = "https://asu.samgk.ru/api/schedule/teacher/$date/$teacherKey"
        val response = fetchData(url)
        return parseResponse(response)
    }

    fun getCabinetSchedule(cabinetKey: String, date: String): List<Lesson> {
        val url = "https://asu.samgk.ru/api/schedule/cabs/$date/cabNum/$cabinetKey"
        val response = fetchData(url)
        return parseResponse(response)
    }

    private fun fetchData(url: String): String {
        val request = Request.Builder()
                .url(url)
                .build()

        return try {
            val response = client.newCall(request).execute()
            response.body?.string() ?: ""
        } catch (e: IOException) {
            e.printStackTrace()
            ""
        }
    }

    private fun parseResponse(response: String): List<Lesson> {
        val lessons = mutableListOf<Lesson>()

        try {
            val jsonArray = JSONArray(response)
            for (i in 0 until jsonArray.length()) {
                val jsonLesson: JSONObject = jsonArray.getJSONObject(i)
                val lesson = Lesson(
                        title = jsonLesson.optString("title", ""),
                        num = jsonLesson.optInt("num", 0),
                        teacherName = jsonLesson.optString("teachername", ""),
                        cab = jsonLesson.optString("cab", "")
                )
                lessons.add(lesson)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return lessons
    }
}
