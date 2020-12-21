package main

import (
	"database/sql"
	"fmt"
	"math/rand"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	//seed: 現時点の時間をrandomな数字の生成のseedにする
	rand.Seed(time.Now().UnixNano())
	verCodeMap = make(map[string]int)
	verCodeMapTc = make(map[int]string)

	//gin: framework
	router := gin.Default()

	router.GET("login/:Id", login)
	router.GET("/view/:Id/:courseCode", view)
	router.GET("/record/:courseCode/:studentId", record)
	// router.GET("login/student/:Id", loginSt)
	// router.GET("login/teacher/:Id", loginTc)
	// router.Run(":8080")
	router.RunTLS(":8081", "cert.pem", "key.pem") //port, certFile, keyFile
}

//【DB: userName, password...】
const (
	userName = "xx"
	password = "xx"
	ip       = "127.0.0.1"
	port     = "3306"
	dbName   = "aa"
)

// 【DB: 接続】
func connect() *sql.DB {
	//DBへの接続要求string:"userName:password@tcp(IP:port)/dbName?charset=utf8"
	path := strings.Join([]string{userName, ":", password, "@tcp(", ip, ":", port, ")/", dbName, "?charset=utf8"}, "")

	//DBに接続。_ "github.com/go-sql-driver/mysql"
	DB, err := sql.Open("mysql", path)

	if err != nil {
		fmt.Println("connect err", err)
		return nil
	}
	return DB
}

var verCode int
var verCodeMap map[string]int
var verCodeMapTc map[int]string

//1【login/:Id】->学生/先生: 認証番号、名前、電話番号
func login(c *gin.Context) {
	fmt.Println("-->login") //test

	// DBに接続
	db := connect()
	if db == nil {
		c.String(http.StatusOK, "server is under maintenance")
		return
	}
	defer db.Close()

	// parameter
	Id := c.Param("Id")
	var Name string
	var phoneNumber string

	// DBにSELECT要求: 学生のname, phone
	queryResult := db.QueryRow("SELECT st.name, st.phone FROM st_student as st WHERE sid=?", Id)
	fmt.Println("query ok (st)") //test
	err := queryResult.Scan(&Name, &phoneNumber)
	if err != nil {
		// DBにSELECT要求: 学生でなければ、先生のname, phone
		queryResult = db.QueryRow("SELECT tc.name, tc.phone FROM st_teacher as tc WHERE tid=?", Id)
		fmt.Println("query ok (tc)") //test
		err = queryResult.Scan(&Name, &phoneNumber)
		if err != nil {
			fmt.Println("query mistake: ", err)
			c.String(http.StatusOK, "no result")
			return
		} else {
			//先生
			c.String(http.StatusOK, Name)
			verCode = rand.Intn(9000) + 1000
			verCodeMapTc[verCode] = Id
			fmt.Println(verCodeMapTc)
			fmt.Println("verification code: ", verCode)
		}
	} else {
		//学生
		// c.String(http.StatusOK, "hello "+stName+", verification code is send to your phone"+phoneNumber)
		c.String(http.StatusOK, Name)
		verCode = rand.Intn(9000) + 1000
		verCodeMap[Id] = verCode
		fmt.Println(verCodeMap)
		fmt.Println("verification code: ", verCode)
	}
}

// 2【/view/:studentId/all】
// 【/view/:studentId/:courseCode】
func view(c *gin.Context) {
	fmt.Println("-->view") //test

	db := connect()
	if db == nil {
		c.String(http.StatusOK, "server is under maintenance")
		return
	}
	defer db.Close()

	Id := c.Param("Id")
	courseCode := c.Param("courseCode")
	inputVerCode := c.Query("code")

	// 認証番号を確認
	verCode1, _ := verCodeMap[Id]
	inputVerCode1, _ := strconv.Atoi(inputVerCode)
	tid, ok := verCodeMapTc[inputVerCode1]
	if (inputVerCode1 != verCode1 && !ok) || verCode == 0 || inputVerCode1 == 0 || inputVerCode == "" {
		c.String(http.StatusOK, "please log in.") //二者択一
		// c.String(http.StatusOK, "0") //二者択一
	} else if courseCode == "all" {
		if ok && tid == Id {
			//【view 1】/view/:teacherId/all?code=xxx -> 学生list
			rows, err := db.Query("SELECT st.sid, st.name FROM st_student as st")
			if err != nil {
				fmt.Println("query mistake", err)
				c.String(http.StatusOK, "no result")
			} else {
				// listにする
				responseText := ""
				for rows.Next() {
					var sid string
					var stName string
					err := rows.Scan(&sid, &stName)
					if err != nil {
						fmt.Println("rows fail", err)
					}
					responseText += sid + "    " + stName + "\n"
				}
				c.String(http.StatusOK, responseText)
				return
			}
		} else {
			//【view 2】/view/:studentId/all?code=xxx -> 成績list
			rows, err := db.Query("SELECT cs.name, sc.score FROM st_score as sc JOIN st_course as cs ON sc.crs_code=cs.code WHERE stu_sid=?", Id)
			if err != nil {
				fmt.Println("query mistake", err)
				c.String(http.StatusOK, "no result")
			} else {
				//繰り返し結果を読取る
				responseText := "学科名 点数\n"
				for rows.Next() {
					var csName string
					var score string
					err := rows.Scan(&csName, &score)
					if err != nil {
						fmt.Println("rows fail", err)
					}
					responseText += csName + "  " + score + "\n"
					// c.String(http.StatusOK, " "+csName+"  "+score+"\n")
				}
				// for i, _ range csNames {
				//     responseText += csNames[i] + scores[i]
				// }
				c.String(http.StatusOK, responseText)
				// c.String(http.StatusOK, "学科名: 点数:\n"+strings.Join(csNames, "\n")+strings.Join(scores, "\n"))
			}
		}
	} else {
		// 【view 3】/view/:studentId/:courseCode?code=xxx -> ある学科の成績
		csName, score, ok := viewStIDCsCd(Id, courseCode, c)
		if ok {
			c.String(http.StatusOK, "学科名："+csName+" 点数："+score)
		} else {
			c.String(http.StatusOK, "no result")
		}
	}
}

func viewStIDCsCd(studentId string, courseCode string, c *gin.Context) (string, string, bool) {
	fmt.Println("-->viewStIDCsCd") //test
	var csName string
	var score string
	db := connect()
	queryResult := db.QueryRow("SELECT cs.name, sc.score FROM st_score as sc JOIN st_course as cs ON sc.crs_code=cs.code WHERE stu_sid=? and crs_code=?", studentId, courseCode)
	fmt.Println("query ok")
	err := queryResult.Scan(&csName, &score)
	if err != nil {
		fmt.Println("query mistake", err)
		return "", "", false
	} else {
		return csName, score, true
	}
}

//3【record/:courseCode/:studentId?score=xxx】-> update,insert
//ex.http://localhost:8080/record/b003/xh20200101?score=100
func record(c *gin.Context) {
	fmt.Println("-->record") //test
	db := connect()
	if db == nil {
		c.String(http.StatusOK, "server is under maintenance")
		return
	}
	defer db.Close()
	courseCode := c.Param("courseCode")
	studentId := c.Param("studentId")
	score := c.Query("score")
	inputVerCode := c.Query("code")
	inputVerCode1, _ := strconv.Atoi(inputVerCode)
	_, ok := verCodeMapTc[inputVerCode1]
	if !ok {
		c.String(http.StatusOK, "please log in.")
	} else {
		// DB
		tx, err := db.Begin()
		if err != nil {
			fmt.Println("tx fail: ", err)
			return
		}

		// ->【viewStIDCsCd】:studentId+:courseが存在するか確認
		_, scoreR, ok := viewStIDCsCd(studentId, courseCode, c)

		//if 存在＋一致：すでに記録されている
		if ok && scoreR == score {
			c.String(http.StatusOK, "already recorded.")
		}
		//if 存在+一致しない -> update
		if ok && scoreR != score {
			// sqlRuest := "UPDATE st_score SET score =" + score + "WHERE crs_code=" + courseCode + " and stu_sid=" + studentId
			// stmt, err := tx.Prepare(sqlRuest)
			stmt, err := tx.Prepare("UPDATE st_score SET score = ? WHERE crs_code = ? and stu_sid=?")
			if err != nil {
				fmt.Println("Prepare fail: ", err)
				return
			}
			_, err = stmt.Exec(score, courseCode, studentId)
			// exec
			if err != nil {
				fmt.Println("Exec fail: ", err)
				return
			} else {
				// commit
				tx.Commit()
				// fmt.Println(res.LastInsertId())
				c.String(http.StatusOK, "update succeed")
			}
		} else {
			// if 存在しない -> insert
			stmt, err := tx.Prepare("INSERT INTO st_score (crs_code, stu_sid, score) VALUES (?,?,?)")
			if err != nil {
				fmt.Println("Prepare fail: ", err)
				return
			}
			_, err = stmt.Exec(courseCode, studentId, score)
			if err != nil {
				fmt.Println("Exec fail: ", err)
				return
			} else {
				tx.Commit()
				c.String(http.StatusOK, "record succeed")
			}
		}
	}
}
