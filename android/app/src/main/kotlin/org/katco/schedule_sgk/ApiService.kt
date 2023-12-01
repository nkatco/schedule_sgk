package org.katco.schedule_sgk

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import org.katco.schedule_sgk.model.Lesson
import org.json.JSONArray
import org.json.JSONObject
import java.io.IOException

class ApiService {

    private val client = OkHttpClient()

    suspend fun getGroupSchedule(groupKey: String, date: String): List<Lesson> {
        val url = "https://asu.samgk.ru/api/schedule/$groupKey/$date"
        println(url)
        return withContext(Dispatchers.IO) {
            fetchData(url)
        }
    }

    suspend fun getTeacherSchedule(teacherKey: String, date: String): List<Lesson> {
        val url = "https://asu.samgk.ru/api/schedule/teacher/$date/$teacherKey"
        println(url)
        return withContext(Dispatchers.IO) {
            fetchData(url)
        }
    }

    suspend fun getCabinetSchedule(cabinetKey: String, date: String): List<Lesson> {
        val url = "https://asu.samgk.ru/api/schedule/cabs/$date/cabNum/$cabinetKey"
        println(url)
        return withContext(Dispatchers.IO) {
            fetchData(url)
        }
    }

    private suspend fun fetchData(url: String): List<Lesson> {
        try {
            val request = Request.Builder()
                    .url(url)
                    .build()

            val response = client.newCall(request).execute()
            println(response.body)
            val responseBody = response.body?.string() ?: ""
            return parseResponse(responseBody)
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return emptyList()
    }

    private fun parseResponse(response: String): List<Lesson> {
        val lessons = mutableListOf<Lesson>()

        try {
            val jsonObject = JSONObject(response)

            if (jsonObject.has("lessons")) {
                val lessonsArray = jsonObject.getJSONArray("lessons")

                for (i in 0 until lessonsArray.length()) {
                    val jsonLesson: JSONObject = lessonsArray.getJSONObject(i)
                    val lesson = Lesson(
                            title = jsonLesson.optString("title", ""),
                            num = jsonLesson.optInt("num", 0),
                            teacherName = jsonLesson.optString("teachername", ""),
                            cab = jsonLesson.optString("cab", "")
                    )
                    lessons.add(lesson)
                }
                return lessons
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return emptyList()
    }
}
