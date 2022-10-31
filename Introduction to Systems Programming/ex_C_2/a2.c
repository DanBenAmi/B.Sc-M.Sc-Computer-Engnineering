
// name: Dan Ben Ami  ,  ID:316333079

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


// structures
typedef struct student {
    char* name;
    int  id;
    struct clist* courses;
} student;

typedef struct course {
    char* title;
    int  number;
    struct slist* students;
} course;

typedef struct slist {
    student* info;
    struct slist* next;
} slist;

typedef struct clist {
    course* info;
    struct clist* next;
} clist;


// prototypes
slist* add_student(slist* students, char* name, int id);
clist* add_course(clist* courses, char* title, int number);
void reg_student(slist* students, clist* courses, int id, int number);
void unreg_student(slist* students, int id, int number);
void print_students(slist* students);
void print_courses(clist* courses);
void free_all(slist* sl, clist* cl); 
slist* bubble_sort_slist(slist* head);
clist* bubble_sort_clist(clist* head);
void free_students(slist* sl);
void free_courses_nodes(clist* course_node);
void free_courses(clist* cl);
void free_students_nodes(slist* student_node);


//DO NOT TOUCH THIS FUNCTION
static void getstring(char* buf, int length) {
    int len;
    buf = fgets(buf, length, stdin);
    len = (int)strlen(buf);
    if (buf[len - 1] == '\n')
        buf[len - 1] = '\0';
}

//DO NOT TOUCH THIS FUNCTION 
int main() {
    slist* students = 0;
    clist* courses = 0;
    char  c;
    char  buf[100];
    int   id, num;

    do {
        printf("Choose:\n"
            "    add (s)tudent\n"
            "    add (c)ourse\n"
            "    (r)egister student\n"
            "    (u)nregister student\n"
            "    (p)rint lists\n"
            "    (q)uit\n");

        while ((c = (char)getchar()) == '\n');
        getchar();

        switch (c) {
        case 's':
            printf("Adding new student.\n");

            printf("Student name: ");
            getstring(buf, 100);

            printf("Student ID: ");
            scanf("%d", &id);

            students = add_student(students, buf, id);

            break;

        case 'c':
            printf("Adding new course.\n");

            printf("Course name: ");
            getstring(buf, 100);

            printf("Course number: ");
            scanf("%d", &num);

            courses = add_course(courses, buf, num);

            break;

        case 'r':
            printf("Registering a student to a course.\n");

            printf("Student ID: ");
            scanf("%d", &id);

            printf("Course number: ");
            scanf("%d", &num);

            reg_student(students, courses, id, num);

            break;

        case 'u':
            printf("Unregistering a student from a course.\n");

            printf("Student ID: ");
            scanf("%d", &id);

            printf("Course number: ");
            scanf("%d", &num);

            unreg_student(students, id, num);

            break;

        case 'p':
            printf("Printing Information.\n");

            print_students(students);
            print_courses(courses);

            break;

        case 'q':
            printf("Quitting...\n");
            break;
        }

        if (c != 'q')
            printf("\n");
    } while (c != 'q');

    free_all(students, courses);
    return 0;
}

// functions written by me
slist* add_student(slist* head, char* name, int id) {
    student *new_std = 0;
    slist *new_node = 0, *curr_node = head;
    new_std = (student*)malloc(sizeof(student));  // intializing new student
    if (!new_std)
        exit(1);
    char* new_name = 0;
    new_name = (char*)malloc(strlen(name)*sizeof(char)+1);  // intializing new student
    if (!new_name)
        exit(1);
    strcpy(new_name,name);
    new_std->name = new_name;
    new_std->id = id;
    new_std->courses = NULL;
    new_node = (slist*)malloc(sizeof(slist));   // adding the new student to slist
    if (!new_node)
        exit(1);
    new_node->info = new_std;
    new_node->next = NULL;
    if (!head)
        return new_node;
    while (curr_node->next) {
        curr_node = curr_node->next;
    }
    curr_node->next = new_node;
    return head;
}

clist* add_course(clist* head, char* title, int number) {
    course* new_course;
    clist *new_node, *curr_node = head;
    new_course = (course*)malloc(sizeof(course)); // intializing new course
    if (!new_course)
        exit(1);
    char* new_title = 0;
    new_title = (char*)malloc(strlen(title) * sizeof(char) + 1);  // intializing new student
    if (!new_title)
        exit(1);
    strcpy(new_title, title);
    new_course->title = new_title;
    new_course->number = number;
    new_course->students = NULL;
    new_node = (clist*)malloc(sizeof(clist));   // adding the new course to slist
    if (!new_node)
        exit(1);
    new_node->info = new_course;
    new_node->next = NULL;
    if (!head)
        return new_node;
    while (curr_node->next) {
        curr_node = curr_node->next;
    }
    curr_node->next = new_node;
    return head;
}

void reg_student(slist* students, clist* courses, int id, int number) {
    slist* curr_node_student = students;
    clist* curr_node_course = courses;
    while (curr_node_student->info->id != id) {    //finding the student node
        curr_node_student = curr_node_student->next;
    }
    while (curr_node_course->info->number != number) {  //finding the course node in studet's course list
        curr_node_course = curr_node_course->next;
    }
    clist* new_node_course = (clist*)malloc(sizeof(clist)); //adding the course to the start of student's clist
    if (!new_node_course)
        exit(1);
    new_node_course->info = curr_node_course->info;
    new_node_course->next = curr_node_student->info->courses;
    curr_node_student->info->courses = new_node_course;

    slist* new_node_student = (slist*)malloc(sizeof(slist)); //adding the student to the start of course's slist
    if (!new_node_student)
        exit(1);
    new_node_student->info = curr_node_student->info;
    new_node_student->next = curr_node_course->info->students;
    curr_node_course->info->students = new_node_student;
}

void unreg_student(slist* students, int id, int number) {
    slist* curr_node_student = students;                //finding the student node
    while (curr_node_student->info->id != id) {
        curr_node_student = curr_node_student->next;
    }
    clist* curr_node_course = curr_node_student->info->courses; //finding the course node in studet's course list
    while (curr_node_course->info->number != number) {
        curr_node_course = curr_node_course->next;
    }
    slist* student_node_from_course = curr_node_course->info->students; // deleting the student from course's student list
    if (student_node_from_course->info->id == id) {
        curr_node_course->info->students = curr_node_course->info->students->next;
        free(student_node_from_course);
    }
    else {
        while (student_node_from_course->next->info->id != id) {
            student_node_from_course = student_node_from_course->next;
        }
        slist* tmp = student_node_from_course->next;
        student_node_from_course->next = student_node_from_course->next->next;
        free(tmp);
    }
    curr_node_course = curr_node_student->info->courses; //deleting course from student's course list
    if (curr_node_course->info->number == number) {
        curr_node_student->info->courses = curr_node_course->next;
        free(curr_node_course);
    }
    else {
        while (curr_node_course->next->info->number != number) {
            curr_node_course = curr_node_course->next;
        }
        clist* tmp2 = curr_node_course->next;
        curr_node_course->next = curr_node_course->next->next;
        free(tmp2);
    }
    return;
}

clist* bubble_sort_clist(clist* head) {
    int swapped = 0;
    clist* last_node = 0, * curr_node;
    course* tmp_info;
    if (head == NULL)
        return NULL;
    do
    {
        swapped = 0;
        curr_node = head;

        while (curr_node->next != last_node)
        {
            if (curr_node->info->number > curr_node->next->info->number)
            {
                tmp_info = curr_node->info;
                curr_node->info = curr_node->next->info;
                curr_node->next->info = tmp_info;
                swapped = 1;
            }
            curr_node = curr_node->next;
        }
        last_node = curr_node;
    } while (swapped);
    return head;
}

slist* bubble_sort_slist(slist* head) {
    int swapped = 0;
    slist* last_node = 0, * curr_node;
    student* tmp_info;
    if (head == NULL)
        return NULL;
    do
    {
        swapped = 0;
        curr_node = head;

        while (curr_node->next != last_node)
        {
            if (curr_node->info->id > curr_node->next->info->id)
            {
                tmp_info = curr_node->info;
                curr_node->info = curr_node->next->info;
                curr_node->next->info = tmp_info;
                swapped = 1;
            }
            curr_node = curr_node->next;
        }
        last_node = curr_node;
    } while (swapped);
    return head;
}

void print_students(slist* students) {
    students = bubble_sort_slist(students);
    clist* curr_clist = 0;
    printf("STUDENT LIST:");
    if (!students) {
        printf(" EMPTY!\n");
        return;
    }
    printf("\n");
    while (students) {
        printf("%d:%s\n", students->info->id, students->info->name);
        curr_clist = bubble_sort_clist(students->info->courses);
        if (!curr_clist)
            printf("student is not registered for courses.");
        else {
            printf("courses: ");
            printf("%d-%s", curr_clist->info->number, curr_clist->info->title);
            curr_clist = curr_clist->next;
                while (curr_clist) {
                    printf(", %d-%s", curr_clist->info->number, curr_clist->info->title);
                    curr_clist = curr_clist->next;
                }
        }
        printf("\n");
        students = students->next;
    }
}

void print_courses(clist* courses) {
    courses = bubble_sort_clist(courses);
    slist* curr_slist= 0;
    printf("COURSE LIST:");
    if (!courses) {
        printf(" EMPTY!\n");
        return;
    }
    printf("\n");
    while (courses) {
        printf("%d:%s\n", courses->info->number, courses->info->title);
        curr_slist = bubble_sort_slist(courses->info->students);
        if (!curr_slist)
            printf("course has no students.");
        else {
            printf("students: ");
            printf("%d-%s", curr_slist->info->id, curr_slist->info->name);
            curr_slist = curr_slist->next;
            while (curr_slist) {
                printf(", %d-%s", curr_slist->info->id, curr_slist->info->name);
                curr_slist = curr_slist->next;
            }
        }
        printf("\n");
        courses = courses->next;
    }

}

void free_all(slist* sl, clist* cl) {
    free_students(sl);
    free_courses(cl);
}
void free_students(slist* sl) {
    if (!sl)
        return;
    if (sl->next)
        free_students(sl->next);
    free(sl->info->name);
    free_courses_nodes(sl->info->courses);
    free(sl->info);
    free(sl);
}
void free_courses_nodes(clist* course_node) {
    if (!course_node)
        return;
    if (course_node->next)
        free_courses_nodes(course_node->next);
    free(course_node);
}
void free_courses(clist* cl) {
    if (!cl)
        return;
    if (cl->next)
        free_courses(cl->next);
    free(cl->info->title);
    free_students_nodes(cl->info->students);
    free(cl->info);
    free(cl);
}
void free_students_nodes(slist* student_node) {
    if (!student_node)
        return;
    if (student_node->next)
        free_students_nodes(student_node->next);
    free(student_node);
}



