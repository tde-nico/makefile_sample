#####   COLORS   #####

END				= \033[0m

GREY			= \033[30m
RED				= \033[31m
GREEN			= \033[32m
YELLOW			= \033[33m
BLUE			= \033[34m
PURPLE			= \033[35m
CYAN			= \033[36m

HIGH_RED		= \033[91m

#####   INFO   #####

NAME			= program

#####   COMMANDS   #####

CC				= gcc
EXTENSION		= c
CFLAGS			= -Wall -Wextra -Werror
IFLAGS			= -I includes

EXECUTION		= ./$(NAME)
MD				= mkdir -p
RM				= rm -rf

#####   GIT   #####

ADD = git add .
COMMIT = git commit -m
PUSH = git push

#####   RESOURCES   #####

SRC_DIR			= srcs
OBJ_DIR			= objs

SRC_SUB_DIRS	= $(shell find $(SRC_DIR) -type d)
OBJ_SUB_DIRS	= $(SRC_SUB_DIRS:$(SRC_DIR)%=$(OBJ_DIR)%)

SRCS			= $(foreach DIR, $(SRC_SUB_DIRS), $(wildcard $(DIR)/*.$(EXTENSION)))
OBJS			= $(SRCS:$(SRC_DIR)/%.$(EXTENSION)=$(OBJ_DIR)/%.o)



#####   BASE RULES   #####

all: $(NAME)

$(NAME): $(OBJ_SUB_DIRS) $(OBJS)
	@ $(CC) $(CFLAGS) $(OBJS) -o $@
	@ echo "$(GREEN)[+] $(NAME)$(END)"

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.$(EXTENSION)
	@ $(CC) $(CFLAGS) $(IFLAGS) -c $< -o $@
	@ echo "$(BLUE)[+] $@$(END)"

$(OBJ_SUB_DIRS):
	@ $(MD) $(OBJ_SUB_DIRS)
	@ echo "$(PURPLE)[+] $(SRC_DIR) -> $(OBJ_DIR) $(END)"


clean:
	@ $(RM) $(OBJ_DIR)
	@ echo "$(YELLOW)[+] $(OBJ_DIR)$(END)"

fclean: clean
	@ $(RM) $(NAME)
	@ echo "$(YELLOW)[+] $(NAME)$(END)"

re: fclean all

bonus: all



#####   EXTRA RULES   #####

test: all
	clear
	@ $(EXECUTION)

run: test
rrun: fclean test

val: all
	valgrind --leak-check=full $(EXECUTION)
var: val

git:
	@ $(eval MESSAGE := $(or $(m), $(error Usage: make commit m="<commit message>")))
	@ $(ADD)
	@ $(COMMIT) $(MESSAGE)
	@ $(PUSH)


#####   PHONY   #####

.PHONY: all clean fclean re bonus test run rrun val var git
