const db = require('../config/db');
var nodemailer = require('nodemailer');


class UserModel{

     /* *********** send mail */

     static async sendEmail(to,subject,message){

        var transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
              user: 'Put your Email here',
              pass: 'bzfz pnyt tvmb jhlo'
            }
          });
          
          var mailOptions = {
            from: 'mohammedamine.dridi.esprit@gmail.com',
            to: to,
            subject: subject,
            text: message
          };
          
          transporter.sendMail(mailOptions, function(error, info){
            if (error) {
              console.log(error);
            } else {
              console.log('Email sent: ' + info.response);
            }
          });       
    }


    static async getAllUsers(){
        return new Promise((resolve,reject) =>{
                db.query("SELECT * FROM users" , [] , (error,result)=>{
                        if (!error){
                            resolve(result);
                            console.log(result);
                        }
                });
        });
    }
    // get users except me (for users selection to add to board)
    static async getAllUsersExcept(userid){
        return new Promise((resolve,reject) =>{
                db.query("SELECT * FROM users WHERE id <> "+userid.toString() , [] , (error,result)=>{
                        if (!error){
                            resolve(result);
                            console.log(result);
                        }
                });
        });
    }

    static async getUserById(id){
        return new Promise((resolve,reject) =>{
                db.query("SELECT * FROM users where id = "+id.toString() , [] , (error,result)=>{
                        if (!error){
                            resolve(result);
                            console.log(result);
                        }
                });
        });
    }

    static async deleteUser(id){
        return new Promise((resolve,reject) =>{
                db.query("delete from users where id = "+id.toString() , [] , (error,result)=>{
                        if (!error) {
                            resolve(result);
                            console.log(result);
                        }
                });
        });
    }

    /* ************************** WELCOME PAGE (Login) ************************** */


    static async getUserByEmailPassword(email,password){
        var query = "SELECT * FROM users where email = '"+email.toString()+"' AND password = '"+password.toString()+"'";
        console.log(query);
        return new Promise((resolve,reject) =>{
                db.query(query, [] , (error,result)=>{
                        if (!error){
                            resolve(result);
                            console.log(result);
                        }
                });
        });
    }


    /* ************************** CREATE ACCOUNT PAGE (sign up) ************************** */

    static async addUser(userName,email,password,phoneNumber,photoPath){
        var query = "insert into users (userName,email,password,phoneNumber,photoPath) values ('"+userName+"','"+email+"','"+password+"',"+phoneNumber+",'"+photoPath+"')";
        console.log(query);
        return new Promise((resolve,reject) =>{
                db.query( query,
                [] ,
                (error,result)=>{
                    console.log(query);
                        if (!error){
                            resolve(result);
                            console.log(result);
                        }
                });
        });
    }

    /* ************************** FORGET PASSWORD PAGE (reset password) ************************** */

    static async getUserPassword(email){ // shared pref id = new_id + 1
        var query = "SELECT password FROM users where email = '"+email.toString()+"'";
        console.log(query);
        return new Promise((resolve,reject) =>{
                db.query(query, [] , (error,result)=>{
                        if (!error){
                            resolve(result);
                            console.log(result);
                        }
                });
        });
    }

/* ************************** MAIN PAGE (List of tasks and boards) ************************** */


/******* get percentage of tasks done  : nbr of tasks done / nbr tasks */

static async getPercentageTasksDone(user_id){ // shared pref id = new_id + 1
    var query = "SELECT ROUND(((COUNT(*) * 1.0) / (SELECT COUNT(*) FROM tasks t JOIN boards b ON JSON_CONTAINS(b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR))) WHERE (b.createdBy = "+user_id+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id+") IS NOT NULL))) * 100) AS percentage FROM tasks t JOIN boards b ON JSON_CONTAINS(b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR))) WHERE (b.createdBy = "+user_id+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id+") IS NOT NULL) AND t.taskStatus = 1;";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/* *********** get list of users = fct (board_id) ==> to get (users images) for boards list */

static async getListUsers_Boards(board_id){
    var query = "SELECT u.* FROM users u JOIN boards b ON JSON_CONTAINS(b.assignedTo, JSON_QUOTE(CONVERT(u.id, CHAR)) ) WHERE JSON_SEARCH(b.assignedTo, 'one', u.id) IS NOT NULL AND b.id = "+board_id.toString();
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

static async get_Not_ListUsers_Boards(boardId){
    var query = "SELECT * FROM users WHERE id NOT IN (SELECT u.id FROM users u JOIN boards b ON JSON_CONTAINS(b.assignedTo, JSON_QUOTE(CONVERT(u.id, CHAR))) WHERE b.id = "+boardId.toString()+" )";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });

}

/* *********** get list of users = fct (task_id) ==> to get (users images) for tasks list */

static async getListUsers_Tasks(task_id){
    var query = "SELECT DISTINCT u.* FROM users u JOIN boards b ON JSON_CONTAINS(b.assignedTo, JSON_QUOTE(CONVERT(u.id, CHAR))) JOIN tasks t ON t.boardId = b.id WHERE JSON_SEARCH(b.assignedTo, 'one', CAST(u.id AS CHAR)) IS NOT NULL AND t.id = "+task_id.toString();
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}


/* *********** get list of boards = fct (user_id) */

static async getListBoards(user_id){
    var query = "select * from boards where createdBy = "+user_id.toString()+" OR JSON_SEARCH(assignedTo,'one',"+user_id.toString()+") IS NOT NULL";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/* *********** get list of tasks = fct (user_id , boardid)  : */

static async getListTasksByBoardId(user_id,boardId){ //user_id = BoardcreatedBy
    var query = "SELECT t.*,b.* FROM tasks t JOIN boards b ON JSON_CONTAINS( b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL) AND b.id = "+boardId.toString();
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/* *********** get list of tasks = fct (user_id , boardid & FILTER 'taskName & taskStatus & taskDate')  : */
// board detail filter (task filtering)

/*
static async getListTasksByBoardId_Filter(baseQuery,user_id,boardId,taskName,taskStatus,taskDateMin,taskDateMax){ //user_id = BoardcreatedBy
    //SELECT t.*,b.* FROM tasks t JOIN boards b ON JSON_CONTAINS( b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL) AND b.id = "+boardId.toString()
    /*
    if (taskName != ""){
        baseQuery += " AND t.taskName = '"+taskName+"' ";
    }
    if (taskStatus != null){
        baseQuery += " AND t.taskStatus = "+taskStatus;
    }
    if ( (taskDateMin != "")  && (taskDateMax != "")  ){
        baseQuery += " AND t.taskCreationDate BETWEEN '"+taskDateMin+"' AND '"+taskDateMax+" 23:59:00' ";
    }
    
    console.log(baseQuery);
    return new Promise((resolve,reject) =>{
            db.query(baseQuery, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}
*/
static async getListTasks(user_id){ //user_id = BoardcreatedBy
    var query = "SELECT t.*,b.* FROM tasks t JOIN boards b ON JSON_CONTAINS( b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL)";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}




/* *********** get list of tasks = fct (user_id)  : */

static async getListTasksFilter(user_id,taskCreationDate,taskStatus){ // example : (user_id,Date.now(),0)
    var query;
    if (taskStatus == "all"){
        query = "SELECT t.*,b.name,b.assignedTo FROM tasks t JOIN boards b ON JSON_CONTAINS( b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL) AND DATE(taskCreationDate) = '"+taskCreationDate+"' ";
    } else {
        query = "SELECT t.*,b.name,b.assignedTo FROM tasks t JOIN boards b ON JSON_CONTAINS( b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL) AND DATE(taskCreationDate) = '"+taskCreationDate+"' AND taskStatus = "+taskStatus;
    }
    
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}


/* *********** get list of tasks (filtred by : taskStatus = 0/1 => active/done) */

static async getListStatusFilterTasks(user_id,taskStatus){ // get inactive/active tasks
    var query = "SELECT t.* FROM tasks t JOIN boards b ON JSON_CONTAINS(b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL ) AND t.taskStatus = "+taskStatus.toString();
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/* *********** get list of tasks (filtred by : taskCreationDate) */

static async getListDateFilterTasks(user_id,startDate,endDate){ // get inactive/active tasks
    var query = "SELECT t.* FROM tasks t JOIN boards b ON JSON_CONTAINS(b.tasksList,  JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL ) AND t.taskCreationDate between '"+startDate.toString()+" 00:00:00' AND '"+endDate.toString()+" 23:59:59.999999' ";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/* *********** get list of tasks (filtred by : status & taskCreationDate) */

static async getListDateStatusFilterTasks(user_id,status,startDate,endDate){ // get inactive/active tasks
    var query = "SELECT t.* FROM tasks t JOIN boards b ON JSON_CONTAINS(b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL ) AND t.taskStatus = "+status.toString()+" AND t.taskCreationDate between '"+startDate.toString()+" 00:00:00' AND '"+endDate.toString()+" 23:59:59.999999 '";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}


/* *********** get nbr of active tasks = fct (user_id) */

static async getNbrActiveTasks(user_id){ // shared pref id = new_id + 1
    var query = "SELECT count(*) as nbrActiveTasks FROM tasks t JOIN boards b ON JSON_CONTAINS(b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL ) AND t.taskStatus = 0";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/* *********** get nbr of active tasks = fct (user_id,board_id) */

static async getNbrActiveTasks_Board(user_id,board_id){ // shared pref id = new_id + 1
    var query = "SELECT count(*) as nbrActiveTasks FROM tasks t JOIN boards b ON JSON_CONTAINS(b.tasksList, JSON_QUOTE(CONVERT(t.id, CHAR)) ) WHERE (b.createdBy = "+user_id.toString()+" OR JSON_SEARCH(b.assignedTo, 'one', "+user_id.toString()+") IS NOT NULL ) AND t.taskStatus = 0 AND b.id = "+board_id.toString();
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}


/* *********** delete boards (only if your the creator of the board) */

static async deleteBoard(id){
    return new Promise((resolve,reject) =>{
            db.query("delete from boards where id = "+id.toString() , [] , (error,result)=>{
                    if (!error) {
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/* *********** delete task (for all users assigned to this task) */

static async deleteTask(id){
    return new Promise((resolve,reject) =>{
            db.query("delete from tasks where id = "+id.toString() , [] , (error,result)=>{
                    if (!error) {
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}


/* ************************** ADD TASK PAGE (List of tasks and boards) ************************** */


static async addTask(boardId,taskName,taskDescription,taskStatus,taskCreationDate){
    //INSERT INTO tasks(boardId, taskName, taskDescription, taskStatus, taskCreationDate) VALUES (4, "Task 555", "Desc task 555", 0, '2024-05-31 12:44:00');
    var query = "insert into tasks(boardId, taskName, taskDescription, taskStatus, taskCreationDate) values ("+boardId+",'"+taskName+"','"+taskDescription+"',"+taskStatus+",'"+taskCreationDate+"')";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query( query,
            [] ,
            (error,result)=>{
                console.log(query);
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/************************************************* ADD BOARD PAGE  **********************************************/

static async getUserFilterByUserName(userId,userName){
    return new Promise((resolve,reject) =>{
            db.query("SELECT * FROM users where userName LIKE '%"+userName.toString()+"%' AND id <> "+userId.toString() , [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}


static async addBoard(name,createdBy,assignedTo){
    // INSERT INTO boards (name, tasksList, createdBy, assignedTo) VALUES ('board 77','[]',2,'["2","1"]')
    var query = "insert into boards (name,tasksList,createdBy,assignedTo) values ('"+name+"','[]',"+createdBy+",'"+assignedTo+"')";
    console.log(query);
    return new Promise((resolve,reject) =>{
            db.query( query,
            [] ,
            (error,result)=>{
                console.log(query);
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

// update board : UPDATE boards SET tasksList = JSON_ARRAY_APPEND(tasksList, '$', '1') WHERE id = 4

static async updateBoard_addTaskToBoard(boardId,taskId){
    var query = "UPDATE boards SET tasksList = JSON_ARRAY_APPEND(tasksList, '$', '"+taskId+"') WHERE id = "+boardId;
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

static async updateBoard_addUsersToBoard(boardId,userId){
    var query = "UPDATE boards SET assignedTo = JSON_ARRAY_APPEND(assignedTo, '$', '"+userId+"') WHERE id = "+boardId;
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

static async getLastTaskId(){
    var query = "SELECT id FROM tasks ORDER BY id DESC LIMIT 1";
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

/******************************** TASK DETAIL PAGE ******************************** */

static async getBoardCreatorUser(boardId){
    var query = "select * from users inner join boards on boards.createdBy = users.id where users.id = (select boards.createdBy from boards where boards.id = "+boardId+") LIMIT 1"
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}

// UPDATE tasks SET taskStatus = CASE WHEN taskStatus = 0 THEN 1 ELSE 0 END WHERE id = 13;


static async reverseTaskStatus(taskId){
    var query = "UPDATE tasks SET taskStatus = CASE WHEN taskStatus = 0 THEN 1 ELSE 0 END WHERE id = "+taskId.toString();
    return new Promise((resolve,reject) =>{
            db.query(query, [] , (error,result)=>{
                    if (!error){
                        resolve(result);
                        console.log(result);
                    }
            });
    });
}


}





module.exports=UserModel;