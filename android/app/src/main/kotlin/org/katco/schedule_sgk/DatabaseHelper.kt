package org.katco.schedule_sgk

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DatabaseProvider(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 1
        private const val DATABASE_NAME = "favorites_database"

        private const val TABLE_FAVORITES = "Favorites"
        private const val KEY = "key"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createTable = ("CREATE TABLE IF NOT EXISTS $TABLE_FAVORITES ($KEY TEXT PRIMARY KEY)")
        db.execSQL(createTable)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_FAVORITES")
        onCreate(db)
    }

    fun insertFavorite(key: String): Long {
        val db = writableDatabase
        val contentValues = ContentValues()
        contentValues.put(KEY, key)
        return db.insert(TABLE_FAVORITES, null, contentValues)
    }

    fun getAllFavorites(): List<String> {
        val favoriteList = mutableListOf<String>()
        val db = readableDatabase
        val cursor: Cursor = db.rawQuery("SELECT * FROM $TABLE_FAVORITES", null)

        if (cursor.moveToFirst()) {
            do {
                favoriteList.add(cursor.getString(cursor.getColumnIndex(KEY)))
            } while (cursor.moveToNext())
        }
        cursor.close()
        return favoriteList
    }

    fun deleteFavorite(key: String): Int {
        val db = writableDatabase
        return db.delete(TABLE_FAVORITES, "$KEY=?", arrayOf(key))
    }
}
