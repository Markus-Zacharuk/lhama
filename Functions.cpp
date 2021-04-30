#include "Header.h"

void substitute(std::any &body, const std::string &variable, const std::any &substitution) {
    auto current_body = &body;
    while (true) {
        // Application: (Lx.y z)
        if (auto application_ptr = std::any_cast<Application>(current_body)) {
            // Handle argument.
            substitute(application_ptr->argument, variable, substitution);
            // Handle the abstraction.
            current_body = &(application_ptr->abstraction);
        // Abstraction: Lx.y
        } else if (auto abstraction_ptr = std::any_cast<Abstraction>(current_body)) {
            if (abstraction_ptr->variable == variable) {
                return;
            }
            current_body = &(abstraction_ptr->body);
        // Variable: x
        } else if (auto string_ptr = std::any_cast<std::string>(current_body)) {
        //    std::cout << "| " << *string_ptr << " in " << body;
            if (*string_ptr == variable) {
                *current_body = substitution;
            }
        //    std::cout << " -> " << *current_body << " in " << body  << "\n";
            return;
        }
    }
    return;
}

void beta_reduction_normal(std::any &expression) {
    auto current_expression = &expression;
    while (true) {
        // Application: (Lx.y z)
        if (auto application_ptr = std::any_cast<Application>(current_expression)) {
            if (auto abstraction_ptr = std::any_cast<Abstraction>(&application_ptr->abstraction)) {
                substitute(
                        abstraction_ptr->body,
                        abstraction_ptr->variable,
                        application_ptr->argument
                );
                // Note: Check for unnecessary copies!
                *current_expression = abstraction_ptr->body;
            } else {
                beta_reduction_normal(application_ptr->abstraction);
                if (!std::any_cast<Abstraction>(&application_ptr->abstraction)) {
                    std::cout << "\n Error: Beta-reduction of application expects abstraction on the left side." <<
                              "\nHere's the expression:\n" << *application_ptr << "\n";
                    return;
                }
            }
        //    std::cout << " -> " << expression << "\n";
            // Abstraction: Lx.y
        } else if (auto abstraction_ptr = std::any_cast<Abstraction>(current_expression)) {
            current_expression = &(abstraction_ptr->body);
            // Variable: x
        } else if (auto string_ptr = std::any_cast<std::string>(current_expression)) {
            return;
        }

    }
}
/*
std::any get_assigned_value(const std::string &name, bool &success) {
    auto search = assignments.find($2);
    if (search != assigments.end()) {
        success = true;
        return std::any(search->second);
    } else {
        std::cout << "Reference Error: can't find '" << $2 <<"'. Aborting evaluation\n";
        success = false;
        return std::any(success);
    }
}
 */