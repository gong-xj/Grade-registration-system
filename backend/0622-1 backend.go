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

//【连接数据库的配置】
const (
	userName = "xx"
	password = "xx"
	ip       = "127.0.0.1"
	port     = "3306"
	dbName   = "aa"
)

//1【record/:courseCode/:studentId?score=xxx】update,insert
//ex.http://localhost:8080/record/b003/xh20200101?score=100
func record(c *gin.Context) {
	fmt.Println("--->record") //测试1

	db := connect() //【连接】
	if db == nil {
		c.String(http.StatusOK, "server is under maintenance")
		return
	}
	defer db.Close()

	courseCode := c.Param("courseCode") //【创建参数】b
	studentId := c.Param("studentId")   //参数a
	score := c.Query("score")           //参数c
	inputVerCode := c.Query("code")     //参数d

	inputVerCode1, _ := strconv.Atoi(inputVerCode)
	_, ok := verCodeMapTc[inputVerCode1]
	if !ok {
		c.String(http.StatusOK, "please log in.")
	} else {
		tx, err := db.Begin() //【开启事务】（修改？）
		if err != nil {
			fmt.Println("tx fail: ", err)
			return
		}

		//【调用viewStIDCsCd，检查:studentId+:course是否存在】
		_, scoreR, ok := viewStIDCsCd(studentId, courseCode, c)

		//【if存在+一样：已录入
		if ok && scoreR == score {
			c.String(http.StatusOK, "already recorded.")
		}
		//【if存在+不一样：update】
		if ok && scoreR != score {
			// sqlRuest := "UPDATE st_score SET score =" + score + "WHERE crs_code=" + courseCode + " and stu_sid=" + studentId
			// stmt, err := tx.Prepare(sqlRuest)
			stmt, err := tx.Prepare("UPDATE st_score SET score = ? WHERE crs_code = ? and stu_sid=?") //【准备sql语句】
			if err != nil {
				fmt.Println("Prepare fail: ", err)
				return
			}

			_, err = stmt.Exec(score, courseCode, studentId) //【将参数传递到sql语句中并且执行】
			if err != nil {
				fmt.Println("Exec fail: ", err)
				return
			} else {
				tx.Commit() //【提交事务】
				// fmt.Println(res.LastInsertId()) //获得上一个插入自增的id
				c.String(http.StatusOK, "update succeed")
			}

		} else {
			//【if不存在：insert】

			stmt, err := tx.Prepare("INSERT INTO st_score (crs_code, stu_sid, score) VALUES (?,?,?)") //【准备sql语句】
			if err != nil {
				fmt.Println("Prepare fail: ", err)
				return
			}

			_, err = stmt.Exec(courseCode, studentId, score) //【将参数传递到sql语句中并且执行】
			if err != nil {
				fmt.Println("Exec fail: ", err)
				return
			} else {
				tx.Commit() //【提交事务】
				// fmt.Println(res.LastInsertId()) //获得上一个插入自增的id
				c.String(http.StatusOK, "record succeed")
			}
		}
	}
}

// 2【/view/:studentId/all】
// 【/view/:studentId/:courseCode】
func view(c *gin.Context) {
	fmt.Println("--->view") //测试1
	db := connect()
	if db == nil {
		c.String(http.StatusOK, "server is under maintenance")
		return
	}
	defer db.Close()
	studentId := c.Param("studentId")   //参数a
	courseCode := c.Param("courseCode") //参数b
	inputVerCode := c.Query("code")     //参数c

	verCode1, _ := verCodeMap[studentId]
	inputVerCode1, _ := strconv.Atoi(inputVerCode)
	_, ok := verCodeMapTc[inputVerCode1]
	// verCode2 := strconv.Itoa(verCode1)
	if (inputVerCode1 != verCode1 && !ok) || verCode == 0 {
		// c.String(http.StatusOK, "please log in.") //2选1
		c.String(http.StatusOK, "0") //2选1
	} else if courseCode == "all" {
		rows, err := db.Query("SELECT cs.name, sc.score FROM st_score as sc JOIN st_course as cs ON sc.crs_code=cs.code WHERE stu_sid=?", studentId)
		if err != nil {
			fmt.Println("查询出错了", err) //测试
			c.String(http.StatusOK, "no result")
		} else {
			//// c.String(http.StatusOK, "学科名 分数\n")
			//循环读取结果
			responseText := "学科名 分数\n" //2选1
			// responseText := "1" //2选1
			for rows.Next() {
				var csName string
				var score string
				//将每一行的结果都赋值到一个user对象中
				err := rows.Scan(&csName, &score)
				if err != nil {
					fmt.Println("rows fail", err)
				}
				responseText += csName + "  " + score + "\n"
				//// c.String(http.StatusOK, " "+csName+"  "+score+"\n")
			}
			//// for i, _ range csNames {
			////     responseText += csNames[i] + scores[i]
			//// }
			c.String(http.StatusOK, responseText)
			// c.String(http.StatusOK, "学科名: 分数:\n"+strings.Join(csNames, "\n")+strings.Join(scores, "\n"))
		}
	} else {
		csName, score, ok := viewStIDCsCd(studentId, courseCode, c)
		if ok {
			c.String(http.StatusOK, "学科名："+csName+" 分数："+score)
		} else {
			c.String(http.StatusOK, "no result")
		}
	}
}

func viewStIDCsCd(studentId string, courseCode string, c *gin.Context) (string, string, bool) {
	fmt.Println("--->viewStIDCsCd") //测试1
	var csName string               //打印1
	var score string                //打印2
	db := connect()
	queryResult := db.QueryRow("SELECT cs.name, sc.score FROM st_score as sc JOIN st_course as cs ON sc.crs_code=cs.code WHERE stu_sid=? and crs_code=?", studentId, courseCode)
	fmt.Println("query ok")
	err := queryResult.Scan(&csName, &score)
	if err != nil {
		fmt.Println("查询出错了", err) //测试
		return "", "", false
	} else {
		return csName, score, true
	}
}

var verCode int
var verCodeMap map[string]int
var verCodeMapTc map[int]string

//3【login/student/:Id】
func loginSt(c *gin.Context) {
	fmt.Println("--->") //测试1
	db := connect()
	if db == nil {
		c.String(http.StatusOK, "server is under maintenance")
		return
	}
	defer db.Close()
	// StTc := c.Param("StTc") //参数a
	// if StTc == "student" {

	Id := c.Param("Id") //参数b
	// } else {
	// 	TeId := c.Param("Id") //参数c
	// }
	var stName string      //打印1
	var phoneNumber string //打印2
	queryResult := db.QueryRow("SELECT st.name, st.phone FROM st_student as st WHERE sid=?", Id)
	fmt.Println("query ok") //测试2
	err := queryResult.Scan(&stName, &phoneNumber)
	if err != nil { //测试3
		fmt.Println("查询出错了", err) //测试
		c.String(http.StatusOK, "no result")
	} else {
		// c.String(http.StatusOK, "hello "+stName+", verification code is send to your phone"+phoneNumber)
		c.String(http.StatusOK, stName)
		verCode = rand.Intn(9000) + 1000
		verCodeMap[Id] = verCode
		fmt.Println(verCodeMap)
		fmt.Println("verification code: ", verCode)
	}
}

//【login/teacher/:Id】
func loginTc(c *gin.Context) {
	fmt.Println("--->") //测试1
	db := connect()
	if db == nil {
		c.String(http.StatusOK, "server is under maintenance")
		return
	}
	defer db.Close()

	Id := c.Param("Id")    //参数b
	var tcName string      //打印1
	var phoneNumber string //打印2
	queryResult := db.QueryRow("SELECT tc.name, tc.phone FROM st_teacher as tc WHERE tid=?", Id)
	fmt.Println("query ok") //测试2
	err := queryResult.Scan(&tcName, &phoneNumber)
	if err != nil { //测试3
		fmt.Println("查询出错了", err) //测试
		c.String(http.StatusOK, "no result")
	} else {
		c.String(http.StatusOK, "hello "+tcName+", verification code is send to your phone"+phoneNumber)
		verCode = rand.Intn(9000) + 1000
		verCodeMapTc[verCode] = Id
		fmt.Println(verCodeMapTc)
		fmt.Println("verification code: ", verCode)
	}
}

func connect() *sql.DB {
	//构建连接："用户名:密码@tcp(IP:端口)/数据库?charset=utf8"
	path := strings.Join([]string{userName, ":", password, "@tcp(", ip, ":", port, ")/", dbName, "?charset=utf8"}, "")

	//打开数据库,前者是驱动名，所以要导入： _ "github.com/go-sql-driver/mysql"
	DB, err := sql.Open("mysql", path)

	if err != nil {
		fmt.Println("connect err")
		fmt.Println(err)
		return nil
	}
	return DB
}

func main() {
	rand.Seed(time.Now().UnixNano())
	verCodeMap = make(map[string]int)
	verCodeMapTc = make(map[int]string)

	router := gin.Default()

	router.GET("/record/:courseCode/:studentId", record)

	router.GET("/view/:studentId/:courseCode", view)

	router.GET("login/student/:Id", loginSt)

	router.GET("login/teacher/:Id", loginTc)

	router.Run(":8080")

}
