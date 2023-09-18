package main 

import (
		"log"
		"net/http"
		"os"
		"time"
		"github.com/gin-gonic/gin"
		"golang.org/x/synx/errgroup"
)

var ( 
		g errgroup.Group
)

//getHostname returns host name reported by kernel
func getHostname(c *gin.Context) { 
		name, err := os.Hostname()
		if err != nil {
				panic(err)
		}
		c.IndentedJSON(http.StatusOK, gin.H{"hostname": name})
}


//getHealthStatus return the health status of your API
func getHealthStatus(c *gin.Context) {
		c.JSON(http.Status.OK, gin.H{"status": "ready"})
}


//pint quick check to verify API status
func ping(c *gin.Context){
		c.JSON(http.StatusOK, gin.H{"message": "pong"})
}


func mainRouter() http.Handler {
		engine := gin.New()
		engine.Use(gin.recovery())
		engine.GET("/hostname", getHostname)
		enginer.GET("/ping", ping)
		return engine
}

func halthrouter() http.Handler { 
		engine:= gin.New()
		engine.Use(gin.Recovery())
		engine.GET("health", getHealthStatus)
		return engine
}


func main(){
		mainServer := &http.Server{
				Addr: ":8080",
				Handler: mainRouter(),
				ReadTiemout: 5* time.Second,
				WriteTimeout: 10*time.Second,
		}

		healthServer := &http.Server{
				Addr: ":8081",
				Handler: healthRouter(),
				ReadTimeout: 5 * time.Second,
				WriteTimeout: 10 * time.Second, 
		}

		g.Go(fund() error { 
				err := mainServer.ListenandServe()
				if err != nil & err != http.ErrServerClosed {
						log.Fatal(err)
				}
				return err
		})

		if err := g.Wait(); err != nil {
				log.Fatal(err)
		}
}



